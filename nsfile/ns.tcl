#=========================================================================
Phy/WirelessPhy set RXThresh_ 1.76149e-10;# 信号最大传输距离为300米时的接收门限
Mac/802_11Ext set dataRate_ 6Mb				;# 选择802_11Ext协议，并设置数据发送速率为6Mb/s
Mac/802_11Ext set basicRate_ 1Mb			;# 选择802_11Ext协议，并设置控制信息发送速率为1Mb/s

#参数剩余，括号中的都是变量名，右边是值
set val(chan)		Channel/WirelessChannel	;# 通道类型，此处为无线通道
set val(prop)		Propagation/TwoRayGround	;# 无线传播模型，此处为两径模型（1.点到点间的直线，2.地面的反射）
set val(netif)		Phy/WirelessPhy			;# 网络接口类型，此处为无线物理层
set val(mac)		Mac/802_11				;# MAC类型选择802_11
set val(ifq)		Queue/DropTail/PriQueue	;# 网卡队列丢失类型，此处为尾部丢失（远距离衰落）
set val(ll)			LL						;#链路层类型
set val(ant)		Antenna/OmniAntenna		;# 无线类型，此处为全向

#设置拓扑平面大小
set val(x) 			13800;
set val(y)			13800;
set val(ifqlen)		30						;# 网卡队列容量
set val(nn)			50					;# 本次模拟中车辆节点的个数
set val(nr)		4						;# 本次模拟中RSU的个数
set val(rtg)		AODV					;# 无线路由协议，ADOV是ns2自带的仿真协议
set val(stop)		100						;# 运行时间
#set val(sc)		"city01_scen_50"
set val(sc)			"vms_scen_file"			;# 导入地图文件
#set val(cp)		"cbr-25-12"
#=========================================================================

#创建仿真器和相应trace数据存储文件
set ns_ [new Simulator]

set tracefd 			[open ns_trace_10_20.tr w]	;# 定义.tr的trace文件，运行结束得到ns_trace.tr
set namtrace		[open ns_nam.nam w]			;#	定义.nam的可视化文件，运行结束时得到ns_nam.nam

$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y);# nam动画跟踪范围：13001*13001

#创建拓扑平面：13001*13001
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y);

#创建30个GOD数据结构，以记录路由信息

set god_ [create-god $val(nn)]

set chan [new $val(chan)]				;# 创建无线信道

$ns_ node-config -adhocRouting $val(rtg) \
				 -llType $val(ll) 		 \
				 -macType $val(mac)		 \
				 -ifqType $val(ifq)		 \
				 -ifqLen  $val(ifqlen)	 \
				 -antType $val(ant)		 \
				 -propType $val(prop) 	 \
				 -phyType  $val(netif)	 \
				 -channel  $chan  		 \
		 -topoInstance $topo  \
		 -agentTrace    ON	  \
				 -routerTrace ON  \
				 -macTrace 	  OFF \
				 -phyTrace	  OFF 
				 
for {set i 0} {$i < $val(nn) } {incr i} {

    set node_($i) [$ns_ node]
}

source $val(sc)

Phy/WirelessPhy set RXThresh_ 1.10093e-11;# RSU信号最大传输距离为600米时的接收门限
set i $val(nn)

set node_($i) [$ns_ node]
$node_($i) set X_ 10548.96
$node_($i) set Y_ 12058.48
$node_($i) set Z_ 0.0
$node_($i) random-motion 0


incr i
set node_($i) [$ns_ node]
$node_($i) set X_ 10548.96
$node_($i) set Y_ 12558.48
$node_($i) set Z_ 0.0
$node_($i) random-motion 0


incr i
set node_($i) [$ns_ node]
$node_($i) set X_ 11048.96
$node_($i) set Y_ 12058.48
$node_($i) set Z_ 0.0
$node_($i) random-motion 0

incr i
set node_($i) [$ns_ node]
$node_($i) set X_ 11048.96
$node_($i) set Y_ 12558.48
$node_($i) set Z_ 0.0
$node_($i) random-motion 0


for {set i 0} {$i < [expr $val(nn)+$val(nr)]} {incr i} {
	
	set agent_($i) [new Agent/PBC]
	$ns_ attach-agent $node_($i) $agent_($i)
	$agent_($i) set Pt_ 1e-4 
	$agent_($i) set payloadSize 392		;# 分组大小
	$agent_($i) set periodicBroadcastInterval 0.1 ;# 广播周期为100毫秒
	$agent_($i) set periodicBroadcastVariance 0.05
	$agent_($i) set modulationScheme 0
	$agent_($i) PeriodicBroadcast ON	
}

for {set i 0} {$i < [expr $val(nn)+ $val(nr)] } {incr i} {

	$ns_ initial_node_pos $node_($i) 30
}

# 仿真结束时重置节点
for {set i 0} {$i < [expr $val(nn)+$val(nr)]} {incr i} {

	$ns_ at $val(stop) "$node_($i) reset";

}


proc finish {} {
	
	global ns_ tracefd namtrace
	$ns_ flush-trace
	close $tracefd
	close $namtrace
	#exec nam ns_nam.nam &	;# 可运行ns_nam.nam文件，出现可视化窗口
	exit 0
}

#仿真结束时调用结束进程
$ns_ at $val(stop) "finish"

puts "Start Simulation..."
# run the simulation
$ns_ run
