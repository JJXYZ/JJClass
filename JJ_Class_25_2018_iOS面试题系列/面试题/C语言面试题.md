###C语言面试题

* -1在内存里面是怎么存的

* ＃include <filename.h> 和 ＃include "filename.h" 有什么区别？

* 写一个宏MIN，这个宏输入两个参数并返回较小的一个

* 用变量a给出下面的定义  
> 一个整型数  
一个指向整型数的指针  
一个指向指针的的指针，它指向的指针是指向一个整型数  
一个有10个整型数的数组  
一个有10个指针的数组，该指针是指向一个整型数  
一个指向有10个整型数数组的指针  
一个指向函数的指针，该函数有一个整型参数并返回一个整型数  
一个有10个指针的数组，该指针指向一个函数，该函数有一个整型参数并返回一个整型数  

* 关键字static的作用是什么

* 关键字const是什么含意？ 分别解释下列语句中const的作用？
> const int a;  
int const a;  
const int *a;  
int * const a;  
int const * a const;  

* 下列交换方法

 ````
 void swap1(int p1, int p2) {
    	int p;
    	p = p1;
    	p1 = p2;
    	p2 = p;
}
void swap(int *p1, int *p2 ) {  
    	int p;  
    	p = *p1;  
    	*p1 = *p2;  
    	*p2 = p;  
}
  ````  

* 为什么标准头文件都有类似以下的结构？
> ifndef　XNOnline_UtilsMacro_h  
 define　XNOnline_UtilsMacro_h  
 endif 
 
* 堆和栈的区别？
* struct 和 class 的区别
* 在不用第三方参数的情况下，交换两个参数的值
* 局部变量能否和全局变量重名？ 
* 局部变量/全局变量/动态申请数据分别存在于哪里？
* 队列和栈有什么区别？用两个栈实现一个队列的功能？要求给出算法和思路！
* 进程和线程的区别。
* 数组和链表的区别
* 给出下列程序的结果. 
> char str1[] = "abc";   
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

* 排序方法：冒泡排序/选择法排序
* 链表，反转链表，双/单向链表


    