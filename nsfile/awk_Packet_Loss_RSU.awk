BEGIN {#模拟前，数据初始化
	nodes = 54;#节点个数
	packet_sent[nodes] = 0;#每个节点对应一个发包计数器
	packet_recvd[nodes] = 0;#每个节点对应一个接包计数器
	ratio_vd[nodes] = 0;#每个节点对应的验证比率
	
	sent_total = 0;# 总收包数
	recvd_total = 0;# RSU总发送包数
	ratio_verify = 0;#总比率和
	pkt_Loss_ratio = 0;#丢包率
	
	verify_time = 0.0268801;#单次验证时间
	run_time = 100;#总运行时间
	
	n_verify = run_time/verify_time;
	print n_verify;
}

{
        #$变量分别按照序号对应tr文件中的字段
	event = $1;#第一个字段：事件
	time = $2;
	node = $3;
	len = length(node);
	node_id = substr(node,2,len-2);	

	#node_id = substr($3,2,1);#第三个字段从第二位开始的一个子字段，即节点id
	layer = $4;
	pkt_type = $7;
	

	if(pkt_type == "PBC" && event == "s" && layer == "AGT"){
        #计算每个节点发出的包的个数
		for(i=0; i<nodes; i++) {
			if ( i == node_id ) 
				packet_sent[i] = packet_sent[i] + 1;
		}
	} else if(pkt_type = "PBC" && event == "r" && layer == "AGT"){
        #计算每个节点接受到的包的个数
		for(i=0; i<nodes; i++) {
			if ( i == node_id ) 
				packet_recvd[i] = packet_recvd[i] + 1;
		}
	}
	
	

}

END {
	num = nodes - 4;	
	for(i=0;i<nodes;i++) {
        #计算每个节点发出的包和接收到的包的个数，应该接收到其他节点发来的包的个数
        	sent_total = sent_total + packet_sent[i];
		printf("%d %d \n",i, packet_recvd[i]) > "pktrecvd.txt";
                printf("%d %d \n",i, packet_sent[i]) > "pktsent.txt";

	}
	for(i=num; i<nodes;i++)
	{	
		if(n_verify >= packet_recvd[i])
		{
			recvd_total = recvd_total + packet_recvd[i];
		}
		else
		{
			recvd_total = recvd_total + n_verify;
		}		
	}
		
	print recvd_total;
        print sent_total;
	pkt_Loss_ratio = (1-recvd_total/sent_total)/4;

	printf("Packet Loss Ratio 		:	%.6f\n",pkt_Loss_ratio);
}
