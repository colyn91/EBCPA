BEGIN { 
	highest_uid = 0; 
	nodes = 54;# 节点个数
	v_num = nodes - 4;
	id_MAX = 300000;# 初始化
	packet_sent[nodes] = 0;#每个节点对应一个发包计数器
	packet_recvd[nodes] = 0;#每个节点对应一个接包计数器
	start_time[id_MAX] = 0;# 每个分组对应的初始时间
	end_time[id_MAX] = 0;# 每个分组对应的结束时间
	repeat_num[id_MAX] = 0;# 每个分组重复接收次数
	packet_duration = 0.0;
	recvnum=0;
	sum=0.0;
	delay=0.0
	i=0;
	sign_time = 0.031850;
	verify_time = 0.02430;
	recvd_num_rsu = 0;
	#run_time = 100;
	#verify_num = run_time / verify_time;
	#print verify_num;
}

{
	event = $1;
	time = $2;
	node = $3;
    	len = length(node);
    	node_id = substr(node,2,len-2);
	trace_type = $4;
	flag = $5;
	uid = $6;#分组uid
	pkt_type = $7;
	pkt_size = $8
		
	if(event=="s" && trace_type=="AGT" && pkt_type=="PBC")
			start_time[uid]=time;
        #每个分组发送包的时间点

	if((event=="r") && (trace_type=="AGT") && (pkt_type=="PBC"))
	{
		end_time[uid]+=time;
	        #每个分组接收到包的时间点
		recvd_num_rsu += 1;
		repeat_num[uid] += 1;
	}
	if(highest_uid < uid)
		highest_uid = uid;
	
}

END {
	print recvd_num_rsu; 
	print highest_uid;
	noun = 0;
	for(i = 0; i <= highest_uid; i++)
	{
		#printf("Packets %d  repeat received times:       %d\n",i,repeat_num[i])> "repeat_num.txt";
		start = start_time[i];
		end = end_time[i];
		#packet_duration = end-start*repeat_num[i];#每组包从发送到被接收所用时间
		#packet_duration = end - start;
		if(start<end){
			packet_duration = end-start*repeat_num[i];#每组包从发送到被接收所用时间
			sum += packet_duration;#所有时间
			recvnum++;#接收次数	
			printf("Packets %d  delay    :      %.6f\n", i, packet_duration) > "delay.txt";
			printf("Packets %d  sent time   :       %.6f\n",i,start)> "start_time.txt";
	                printf("Packets  %d Received time       %.6f\n",i,end)> "end_time.txt";	
			printf("Packets %d  repeat received times:       %d\n",i,repeat_num[i])> "repeat_num.txt";
		}
		noun += repeat_num[i];
	} 
	#print recvnum;
	print noun;
	print sum;
	delay=sum/recvd_num_rsu + sign_time;#平均时延
	delay+=verify_time;
	printf("Average End to End Delay 	:%.9f s\n", delay);
}
