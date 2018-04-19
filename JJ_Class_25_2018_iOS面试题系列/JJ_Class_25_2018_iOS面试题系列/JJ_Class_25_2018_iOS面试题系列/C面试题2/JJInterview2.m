//
//  JJInterview2.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/17.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJInterview2.h"


/**
 struct name1{
     char str;
     short x;
     int  num;
 }
 struct name2{
     char str;0
              1 2 3
     int num; 4 5 6 7
     short x; 8 9
              10 11
 }
 sizeof(struct name1)=?
 sizeof(struct name2)=?
 
8、12
 */


/**
 97. 读文件file1.txt的内容（例如）：
 */


/**
 98. 一个递归反向输出字符串的例子,经典例程.
 void inverse(char *p)
 {
     if( *p = = '\0' )
     return;
     inverse( p+1 );
     printf( "%c", *p );
 }
 int main(int argc, char *argv[])
 {
     inverse("abc\0");
     return 0;
 }
 
 */


/**
 99. 用递归算法判断数组a[N]是否为一个递增数组。递归的方法，记录当前最大的，并且判断当前的是否比这个还大，大则继续，否则返回false结束：
 
 bool fun( int a[], int n )
 {
     if( n= =1 )
     return true;
     if( n == 2 )
     return a[n-1] >= a[n-2];
     return ( a[n-1] >= a[n-2] ) && fun( a,n-1);
 }
 a[5] = {0,1,2,3,4}
 1.fun(a,5)
 4.fun(a,4)
 3.fun(a,3)
 4.fun(a,2)
 
 */


/**
 100. 什么是可重入性？
 可重入（reentrant）函数可以由多于一个任务并发使用，而不必担心数据错误。相反，不可重入（non-reentrant）函数不能由超过一个任务所共享，除非能确保函数的互斥（或者使用信号量，或者在代码的关键部分禁用中断）。可重入函数可以在任意时刻被中断，稍后再继续运行，不会丢失数据。可重入函数要么使用本地变量，要么在使用全局变量时保护自己的数据。
 
 可重入函数：
 不为连续的调用持有静态数据。
 不返回指向静态数据的指针；所有数据都由函数的调用者提供。
 使用本地数据，或者通过制作全局数据的本地拷贝来保护全局数据。
 如果必须访问全局变量，记住利用互斥信号量来保护全局变量。
 绝不调用任何不可重入函数。
 */


/**
 101. 给出下列程序的结果：
 char str1[] = "abc";
 char str2[] = "abc";
 const char str3[] = "abc";
 const char str4[] = "abc";
 const char *str5 = "abc";
 const char *str6 = "abc";
 char *str7 = "abc";
 char *str8 = "abc";
 
 cout < < ( str1 == str2 ) < < endl;
 cout < < ( str3 == str4 ) < < endl;
 cout < < ( str5 == str6 ) < < endl;
 cout < < ( str7 == str8 ) < < endl;
 
结果是：0 0 1 1 str1,str2,str3,str4是数组变量，它们有各自的内存空间；而str5,str6,str7,str8是指针，它们指向相同的常量区域。
 */


/**
 102. 以下代码中的两个sizeof用法有问题吗？
 void UpperCase( char str[] ) // 将 str 中的小写字母转换成大写字母
 {
    for( size_t i=0; i <sizeof(str)/sizeof(str[0]); ++i )
    if( 'a' <=str[i] && str[i] <='z' )
    str[i] -= ('a'-'A' );
 }
 char str[] = "aBcDe";
 cout < < "str字符长度为: " < < sizeof(str)/sizeof(str[0]) < < endl;
 UpperCase( str );
 cout < < str < < endl;
 
 答案：函数外的str是一个静态定义的数组，因此其大小为6，因为还有'\0'，
 函数内的sizeof(str)返回4。
 */


/**
 103. 一个32位的机器,该机器的指针是多少位答案：
 指针是多少位只要看地址总线的位数就行了。80386以后的机子和ARM都是32的数据总线。所以指针的位数就是4个字节了。
 */


/**
 104. 请问以下代码有什么问题：
 int  main()
 {
     char a; a 是一个字节
     char *str=&a;
     strcpy(str,"hello");
     printf(str);
     return 0;
 }
 
 答案：没有为str分配内存空间，将会发生异常问题出在将一个字符串复制进一个字符变量指针所指地址。虽然可以正确输出结果，但因为越界进行内在读写而导致程序崩溃。
 */


/**
 105. int (*s[10])(int) 表示的是什么啊？（右结合）
 答案：int (*s[10])(int) 函数指针数组，每个指针指向一个int func(int param)的函数。
 */


/**
 106. 有以下表达式：
 int a=248;
 int b=4;
 int const c=21;
 const int *d=&a;
 int *const e=&b;
 int const *f const =&a;
 请问下列表达式哪些会被编译器禁止？为什么？ c=32;d=&b;d=43;e=34;e=&a;f=0x321f;
 
 答案：
 *c 这是个什么东东，禁止；
 *d 说了是const， 禁止；
 e = &a 说了是const , 禁止；
 const *f const =&a; 禁止
 */


/**
 107.c和c++中的struct有什么不同？
 答案：c和c++中struct的主要区别是c中的struct不可以含有成员函数，而c++中的struct可以。c++中struct和class的主要区别在于默认的存取权限不同，struct默认为public，而class默认为private
 */


/**
 108.类的静态成员和非静态成员有何区别？
 答案：类的静态成员每个类只有一个，非静态成员每个对象一个
 
 */


/**
 109.纯虚函数如何定义？使用时应注意什么？
 答案：virtual void f()=0; 是接口，子类必须要实现
 
 */


/**
 int main()
 {
     int x=3;
     printf("%d",x);
     return 1;
 }
 问函数既然不会被其它函数调用，为什么要返回1？
 
 答案：mian中，c标准认为0表示成功，非0表示错误。具体的值是某中具体出错信息
 */


/**
 111. 已知一个数组table，用一个宏定义，求出数据的元素个数’
 #define NTBL (sizeof(table)/sizeof(table[0]))
 */


/**
 112. -1,2,7,28,,126请问28和126中间那个数是什么？为什么？
 答案：答案应该是4^3-1=63 规律是n^3-1(当n为偶数0，2，4) n^3+1(当n为奇数1，3，5)
 */


/**
 113.直接链接两个信令点的一组链路称作什么?
 答案：PPP点到点连接
 */


/**
 114. 确定模块的功能和模块的接口是在软件设计的那个队段完成的?
 答案：概要设计阶段
 */


/**
 enum string    {    x1,    x2,    x3=10,    x4,    x5,    }x;
 问x的取值是？
 
 答案：取值在0。1。10。11。12中的一个
 */


/**
 unsigned char *p1;
 unsigned long *p2;
 p1=(unsigned char *)0x801000;
 p2=(unsigned long *)0x810000;
 请问p1+5=  ;        p2+5=  ;
 
答案：801005；810014。不要忘记了这个是16进制的数字，p2要加20变为16进制就是14
 */


/**
 117. Ethternet链接到Internet用到以下那个协议? B
 A.HDLC; B.ARP; C.UDP; D.TCP; E.ID
 */


/**
 118.属于网络层协议的是: B.C
 A.TCP; B.IP传输层; C.ICMP; D.X.25
 */


/**
 119. Windows消息调度机制是: C
 A.指令队列;B.指令堆栈;C.消息队列;D.消息堆栈;
 */


/**
 120.请问下面程序有什么错误?
 int a[60][250][1000],i,j,k;
 for(k=0;k <=1000;k++)
 for(j=0;j <250;j++)
 for(i=0;i <60;i++)
 a[i][j][k]=0;
 
 答案：把循环语句内外换一下
 */


/**
 121. 以下是求一个数的平方的程序,请找出错误:
 #define SQUARE(a)  ((a)*(a))
 int a=5;    int b;
 b=SQUARE(a++);
 
 答案：这个没有问题，s（a＋＋），就是（（a＋＋）×（a＋＋））唯一要注意的就是计算后a＝7了
 */


/**
 122. 分析下列程序有什么问题

 typedef unsigned char BYTE
 int examply_fun(BYTE gt_len; BYTE *gt_code)
 {
     BYTE *gt_buf;
     gt_buf=(BYTE *)malloc(Max_GT_Length);
 
     ......
 
     if(gt_len>Max_GT_Length)
     {
         return GT_Length_ERROR;
     }
 
 .......   //free
 
 }
 

 */


/**
 123. static全局变量与普通的全局变量有什么区别？
 static局部变量和普通局部变量有什么区别？
 static函数与普通函数有什么区别？

 答案：全局变量(外部变量)的说明之前再冠以static 就构成了静态的全局变量。全局变量本身就是静态存储方式，静态全局变量当然也是静态存储方式。 这两者在存储方式上并无不同。这两者的区别虽在于非静态全局变量的作用域是整个源程序， 当一个源程序由多个源文件组成时，非静态的全局变量在各个源文件中都是有效的。而静态全局变量则限制了其作用域， 即只在定义该变量的源文件内有效， 在同一源程序的其它源文件中不能使用它。由于静态全局变量的作用域局限于一个源文件内，只能为该源文件内的函数公用，因此可以避免在其它源文件中引起错误。从以上分析可以看出， 把局部变量改变为静态变量后是改变了它的存储方式即改变了它的生存期。把全局变量改变为静态变量后是改变了它的作用域，限制了它的使用范围。 static函数与普通函数作用域不同。仅在本文件。只在当前源文件中使用的函数应该说明为内部函数(static)，内部函数应该在当前源文件中说明和定义。对于可在当前源文件以外使用的函数，应该在一个头文件中说明，要使用这些函数的源文件要包含这个头文件 static全局变量与普通的全局变量有什么区别：static全局变量只初使化一次，防止在其他文件单元中被引用; static局部变量和普通局部变量有什么区别：static局部变量只被初始化一次，下一次依据上一次结果值； static函数与普通函数有什么区别：static函数在内存中只有一份，普通函数在每个被调用中维持一份拷贝
 
 */


/**
 124. 判断题
 1、有数组定义int a[2][2]={{1},{2,3}};则a[0][1]的值为0。（正确）
 2、int (*ptr) (),则ptr是一维数组的名字。（错误 int (*ptr) ();定义一个指向函数的指针变量）
 3、指针在任何情况下都可进行>, <,>=, <=,==运算。（ 错误 ）
 //指针类型不同的时候
 4、switch(c) 语句中c可以是int ,long,char ,float （//错）,unsigned int 类型。（ 错，不能用实形 ）
 

 */


/**
 char str[ ]= ＂Hello＂;
 char *p=str;
 int n=10;
 sizeof(str)=(    6  )
 sizeof(p)=(      )
 sizeof(n)=(      )
 void func(char str[100])
 {
 ··· ···
 }
 sizeof(str)=(    )
 
答案：6，4，4，4,
 */


/**
 126．不使用库函数，编写函数int strcmp(char *source, char *dest) 相等返回0，不等返回-1；
 答案：一、
 int strcmp(char  *source, char *dest)
 {
 assert((source!=NULL)&&(dest!=NULL));
 int i;
 for(i=0; source[i]==dest[i]; i++)
 {
 if(source[i]=='\0' && dest[i]=='\0')
 return 0;
 else
 return -1;
 }
 }
 
 答案：二、
 int strcmp(char *source, char *dest)
 {
 If ( ) { }
 while ( (*source != '\0') && (*source == *dest))
 {
 source++; dest++;
 }
 return ( (*source) - (*dest) ) ? -1 : 0;
 }
 

 */


/**
 127. 写一函数int fun(char *p)判断一字符串是否为回文,是返回1，不是返回0，出错返回-1 eg:12321
 答案：一、
 int fun(char *p)
 {  if(p==NULL)
 return -1;
 else
 {  int length = 0;  int i = 0;  int judge = 1;  length = strlen(p);
 for(i=0; i <length/2; i++)
 {    if(p[i]!=p[length-1-i])
 { judge = 0;
 break;
 }
 }
 if(judge == 0)
 return 0;
 else
 return 1;
 }
 }
 答案：二、
 int fun(char *p)
 {
 int len = strlen(p) - 1;
 char *q = p + len;
 if (!p) return -1;
 while (p < q)
 {
 if ((*p++) != (*q--))
 return 0;
 }
 return 1;
 }
 

 */


/**
 128.
 (1).在OSI 7 层模型中,网络层的功能有( B) //ip地址
 A.确保数据的传送正确无误 //传输层 B.确定数据包如何转发与路由 C.在信道上传送比特流 D.纠错与流控
 
 (2).FDDI 使用的是___局域网技术。(C )
 A.以太网; B.快速以太网; C.令牌环; D.令牌总线。
 注： (光纤分布数据接口（FDDI）是目前成熟的LAN技术中传输速率最高的一种)
 
 (3).下面那种LAN 是应用CSMA/CD协议的（C)
 A.令牌环 B.FDDI C.ETHERNET D.NOVELL
 
 (4).TCP 和UDP 协议的相似之处是 (C )
 A.面向连接的协议 B.面向非连接的协议 C.传输层协议 D.以上均不对
 
 (5).应用程序PING 发出的是___报文.(C )
 A.TCP 请求报文。 B.TCP 应答报文。 C.ICMP 请求报文。 D.ICMP 应答报文。
 
 (6).以下说法错误的是(多) (BD )
 A.中继器是工作在物理层的设备 B.集线器和以太网交换机工作在数据连路层 C.路由器是工作在网络层的设备 D.桥能隔离网络层广播
 
 (7).当桥接收的分组的目的MAC地址在桥的映射表中没有对应的表项时,采取的策略是( C)
 A.丢掉该分组 B.将该分组分片 C.向其他端口广播该分组 D.以上答案均不对
 
 (8).LAN Switch（局域网交换机） 在网络层次模型中的地位( B)
 A.物理层 B.链路层 C.网络层 D.以上都不是
 
 (9).小于___的TCP/UDP端口号已保留与现有服务一一对应,此数字以上的端口号可自由分配。( C)
 A.199 B.100 C.1024 D.2048
 
 (10).当一台主机从一个网络移到另一个网络时,以下说法正确的是 (B )
 A.必须改变它的IP 地址和MAC 地址
 B.必须改变它的IP 地址,但不需改动MAC 地址
 C.必须改变它的MAC 地址,但不需改动IP 地址
 D.MAC 地址.IP 地址都不需改动
 

 */


/**
 129. 找错
 #define MAX_SRM 256
 DSNget_SRM_no()
 {
 static int SRM_no;
 int I;
 for(I=0;I <MAX_SRM;I++,SRM_no++)
 {
 SRM_no %= MAX_SRM;
 if(MY_SRM.state==IDLE)
 {      break;    }
 }
 if(I>=MAX_SRM)
 return (NULL_SRM);
 else
 return SRM_no;
 }
 
 答： 1，SRM_no没有赋初值
 2，由于static的声明，使该函数成为不可重入（即不可预测结果）函数，因为SRM_no变量放在程序的全局存储区中，每次调用的时候还可以保持原来的赋值。这里应该去掉static声明。
 */


/**
 130. 写出程序运行结果
 int sum(int a)
 {
     auto int c=0;
     static int b=3;
     c+=1;                   //c = 1
     b+=2;                  // b = 5
     return(a+b+c);         // 8
 }
 
 void main()
 {
     int I;
     int a=2;
     for(I=0;I <5;I++)
     {
         printf("%d\n", sum(a));
     }
 }
 
答：8,10,12,14,16 该题比较简单。只要注意b声明为static静态全局变量，其值在下次调用时是可以保持住原来的赋值的就可以。
 */


/**
 int func(int a)
 {
 int b;
 switch(a)
 {
     case 1: b=30;
     case 2: b=20;
     case 3: b=16;
     default: b=0;
 }
 return b;
 } 则func(1)=?
 
答：func(1)=0，因为没有break语句，switch中会一直计算到b=0。这是提醒我们不要忘了break
 */


/**
 132.
 int a[3];
 a[0]=0;
 a[1]=1;
 a[2]=2;
 int *p, *q;
 p=a;
 q=&a[2];
 
 则a[q-p]=?
 
 答：a[q-p]=a[2]=2;这题是要告诉我们指针的运算特点
 */


/**
 133. 定义 int **a[3][4], 则变量占有的内存空间为：_____
 答：此处定义的是指向指针的指针数组，对于32位系统，指针占内存空间4字节，因此总空间为3×4×4＝48。
 */


/**
 134.设有int a=3;则执行语句a+=a-=a*a;后
 变量a的值是?
 结果：a = -12
 */


/**
 Struct RegX
 {
 long bzy:1;
 long wrt:1;
 long rd:1;
 long cnt:4;
 long rsd:25;
 };
 Sizeof(RegX)=?
 
 答案：4
 */


/**
 Char a[]=“hello\0”;// /0系统会自己加的 不管你有没有”/0”
 Char al[7]=“hello”;
 Char *ps=“hello”;
 Strlen(a)= ? Strlen(a1)= ? Strlen(ps)= ?
 Sizeof(a)= ? Sizeof(a1)= ? Sizeof(ps)= ?
 
5 5 5 ，7 7 4
 */


/**
 对于下面的函数,要求打印出”hello”,子程序完全正确的是_（1）（3）_, 一定能打印出”hello”的是_（1）（3）（4）_,有错误的是__（2）（4）
 
 char *GetHellostr(void);
 int main(void)
 {
 char *ps;
 ps= GetHellostr( );
 if(ps != NULL)
 {
 printf(ps);
 }
 return 0;
 }
 (1)
 char *GetHellostr(void)
 {
 char *ps=“hello”;
 return ps;
 }
 (2)
 char *GetHellostr(void)
 {
 char a[]=“hello”;
 return (char *)a;
 }
 (3)
 char *GetHellostr(void)
 {
 static char a[]=“hello”;
 return (char *)a;
 }
 (4)
 char *GetHellostr(void)
 {
 char *ps;
 ps = malloc(10);
 if(NULL ==ps) return NULL;
 strcpy(ps,”hello”);
 return ps;
 }
 
 */


/**
 138.下面程序分别只改到一处,就OK了,要求打印出”welcome to saif”
 void main(void)
 {
 char str1[]=“welcome ”;
 char str2[]=“to ”;
 char str3[]=“saif ”;
 char str[50];
 
 memcpy(str,str1,sizeof(str1));   //  welcome \0
 memcpy(str+sizeof(str1),str2,sizeof(str2));   //welcome \0 to \0
 memcpy(str+strlen(str1)+strlen(str2), str3,sizeof(str3));
 printf(str);
 }
 
 答案：sizeof->strlen
 
 (2)
 void main(void)
 {
 char str1[]=“welcome ”;
 char str2[]=“to ”;
 char str3[]=“saif ”;
 char str[50];
 
 memcpy(str,str1, strlen(str1));
 memcpy(str+strlen(str1),str2, strlen(str2));
 memcpy(str+strlen(str1)+strlen(str2), str3, strlen(str3));
 printf(str);
 
 }
 
 答案：strlen->sizeof
 */


/**
 Struct tag
 {
 short c;
 long b;
 char d;
 long a;
 }
 改变结构体的排列顺序，Sizeof(tag)可能的值?
 
 答案：11、12、16
 */


/**
 140.找出程序中的所有错误
 //分配len的长度的内存,内存地址由ptr输出
 void test_malloc(char **prt, int len)
 {
 char *tmp=NULL;
 tmp=(char*)malloc(len);
 *prt=tmp;
 }
 
 void main(void)
 {
 char *str=“welcome to saif”;
 char *buf;
 char c=0xff;
 test_malloc(&buf, sizeof(str));    //strlen(str)+1
 if(buf ==NULL)                    //(NULL == buf)
 {
 return;
 }
 strcpy(buf , str);
 if( c==(char)0xff)
 {
 printf(“OK,str=%s”,buf);
 }
 else
 {
 printf(“OH my God!”);
 }
 free(buf);
 }
 

 */


/**
 union a {
 int a_int1;
 double a_double;
 int a_int2;
 };                           // 8
 
 typedef struct
 {
 a a1;
 char y;
 } b;
 问题sizeof(b) = ?
 
 答案：12
 */


/**
 142. 用递归法将整数转化为字符串
 void convert( int n )
 {
     int i;
     Char c;
     if ((i=n/10)!=0)
     convert(i);
     c=n%10 +’0’;
     cout<<” “<<c;
 }
 123 –> “123”
 */
@implementation JJInterview2

@end
