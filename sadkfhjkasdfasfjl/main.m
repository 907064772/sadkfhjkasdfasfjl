//
//  main.m
//  sadkfhjkasdfasfjl
//
//  Created by luodp on 16/4/18.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <arpa/inet.h>

int main(int argc, const char * argv[]) {
   
        
    
    int sockListen;
    if ((sockListen = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
        printf("socket fail\n");
        return -1;
    }
    int set = 1;
    setsockopt(sockListen, SOL_SOCKET, SO_REUSEADDR, &set, sizeof(int));
    struct sockaddr_in recvAddr;
    memset(&recvAddr, 0, sizeof(struct sockaddr_in));
    recvAddr.sin_family = AF_INET;
    recvAddr.sin_port = htons(43708);
    recvAddr.sin_addr.s_addr = INADDR_ANY;
    
    if (bind(sockListen, (struct sockaddr *)&recvAddr, sizeof(struct sockaddr))==-1) {
        printf("bind fail \n");
        return -1;
    }
    int recvbytes;
    char recvbuf[128];
    socklen_t addLen = sizeof(struct sockaddr_in);
     while (1) {
        if ((recvbytes = socklen_trecvfrom(sockListen, recvbuf, 128, 0, (struct sockaddr *)&recvAddr, &addLen))!=-1) {
            printf("recvbuf:%s\n",recvbuf);
            recvbuf[recvbytes] = '\0';
            int fd = socket(AF_INET, SOCK_STREAM, 0);
            
            struct sockaddr_in addr;
            addr.sin_addr.s_addr = recvAddr.sin_addr.s_addr;
            printf("%s \n",inet_ntoa(recvAddr.sin_addr));
            printf("%d \n",htons(recvAddr.sin_port));
            addr.sin_port = htons(8080);
            addr.sin_family = AF_INET;
            
            int ret = connect(fd, (struct sockaddr*)&addr, sizeof(addr));
            if(ret < 0)
            {
                perror("connect");
                return 0;
            }
            
            send(fd, "hello", 6, 0);
            
            char buf[1024];
            recv(fd, buf, sizeof(buf), 0);
            
            close(fd);
            
        }else{
            printf("recvfrom fail\n");
            
        }
    
    }
    
    return 0;
}
