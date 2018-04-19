//
//  JJInterview3.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/19.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJInterview3.h"


/**
 143. 枚举元素本身由系统定义了一个表示序号的数值，从0 开始顺序定义为0，1，2…。如在weekday中，sun值为0，mon值为1， …,sat值为6。
 main(){
 　enum weekday
 　{
 　　sun,mon,tue,wed,thu,fri,sat
 　} a,b,c;
 　a=sun;
 　b=mon;
 　c=tue;
 　printf("%d,%d,%d",a,b,c);
 }
 
 只能把枚举值赋予枚举变量，不能把元素的数值直接赋予枚举变量。如：a=sum;b=mon; 是正确的。而：a=0;b=1; 是错误的。如一定要把数值赋予枚举变量，则必须用强制类型转换，如：a=(enum weekday)2;其意义是将顺序号为2的枚举元素赋予枚举变量a，相当于：a=tue; 还应该说明的是枚举元素不是字符常量也不是字符串常量， 使用时不要加单、双引号。
 
 */


/**
 main(){
 　enum body
 　{
 　　a,b,c,d
 　} month[31],j;
 　int i;
 　j=a;
 　for(i=1;i<=30;i++){
 　　month[i]=j;
 　　j++;
 　　if (j>d) j=a;
 　}
 　for(i=1;i<=30;i++){
 　　switch(month[i])
 　　{
 　　　case a:printf(" %2d %c\t",i,'a'); break;
 　　　case b:printf(" %2d %c\t",i,'b'); break;
 　　　case c:printf(" %2d %c\t",i,'c'); break;
 　　　case d:printf(" %2d %c\t",i,'d'); break;
 　　　default:break;
 　　}
 　}
 　printf("\n");
 }
 
 */


/**
 144．用折半查找法求一个数？ 数组a已按从小到大的顺序排列
 
 while((!sign) && (bott <= top))
 {
     mid=(bott + top)/2;
     if(number ==a[mid])
     {
         local=mid;
         printf(“the local is %d\n”,local);
         printf(“the number is%d\n”, number);
         sign =true;
     }
     else if(number < a[min])
     top = mid -1;
     else
     bott=mid+1;
 }
 
 */


/**
 145．有一个字符串，将字符串从第m个字符开始全部复制到另一个新字符串?
 void copystr( char *p1, char *p2, int m)
 {
     int n=0;
     while(n<m-1)
 {
     n++;
     p1++;
 }
 while(*p1 !=’/0’)
 {
     *p2=*p1;
     p1++;
     p2++;
 }
     *p2=’/0’;
 }

 */


/**
 问题一：写出冒泡排序
 
 void bubble_sort(int arr[], int len)
 {
     for (int i = 0; i < len - 1; i++) {
         for (int j = len - 1; j > i; j--) {
             if (arr[j] < arr[j - 1]) {
                 int temp = arr[j];
                 arr[j] = arr[j - 1];
                 arr[j - 1] = temp;
             }
         }
     }
 }

 */


/**
 问题二：写出选择法排序
 void select_sort(int arr[], int len)
 {
     for (int i = 0; i < len; i++) {
         int index = i;
         for (int j = i + 1; j < len; j++) {
             if (arr[j] < arr[index])
                 index = j;
         }
         if (index != i)
         {
             int temp = arr[i];
             arr[i] = arr[index];
             arr[index] = temp;
         }
     }
 }
 
 注释：
 以下为一个用C描述的函数实现上述排序：
 void sort(int array[],int n)
 　　{ // n 为数组元素个数
 　　int i,j,k,temp; // i 为基准位置，j 为当前被扫描元素位置，k 用于暂存出现的较小的元素的位置
 　　for(i=0;i<n-1;i++)
 　　{k=i;//初始化为基准位置
 　　for(j=i+1;j<n;j++)
 　　{
 　　if (array[j]<array[k]) k=j ; // k 始终指示出现的较小的元素的位置
 　　if(k!=i)
 　　{ temp=array[i];
 　　array[i]=array[k];
 　　array[k]=temp; // 将此趟扫描得到的最小元素与基准互换位置
 　　}
 　　} //for
 　　}
 　　}
 
 　　其实现相对简单，效率比较低，时间复杂度为O(n2) （n 的平方） ，为就地排序。
 

 */


/**
 147写一函数creat, 用来建立一个动态链表，各结点数据由键盘输入。
 struct student
 {
 long num;
 float score;
 stuent *next;
 };
 
 student *creat (void)
 {
 student *head;
 student *p1=null,*p2=null;
 int n=0;
 p1=p2=new student;
 cin>>p1->num>>p1->score;
 head=null;
 while(p1->num !=0)
 {
 n=n+1;
 if(1==n) head=p1;
 else
 p2->next=p1;
 p2=p1;
 p1= new student;
 cin>>p1->mum>>p1->score;
 }
 p2->next =NULL;
 return (head);
 }
 
 */


/**
 148，写一print函数，将链表中的各数据遍历输出
 void print(student *head )
 {
 student *p;
 cout<<"there"<<n<<"records"<<endl;
 p=head;
 if(head!=NULL)
 do
 {
 cout<<p->num<<" "<<p->score<<endl;
 p=p->next;
 }while(p!=NULL)
 }
 
 */


/**
 149．写一del函数，用来删除动态链表中，指定的结点数据
 void *del(student *head, long num)
 {
 student *p1,*p2;
 if(head==NULL)
 {return (head);}
 p1=head;
 while(num!=p1->num && p1->next !=NULL)
 {
 p2=p1;
 p1=p1->next;
 }
 if(num == p1->num)
 {
 if(p1==head)
 head=p1->next;
 else
 p2->next=p1->next;
 cout<<"delete:"<<num<<endl;
 n=n-1;
 }
 else
 cout<<"can not find"<<num;
 return(head);
 }
 

 */


/**
 150 写一函数insert,用来向动态链表插入一结点
 Student *insert(student *head, student *stud)
 {
 student *p0 ,*p1, *p2;
 p1=head;
 p0=stud;
 if(head == NULL)
 {
 head=p0;
 p0->next=NULL;
 }
 else
 {
 while((p0->num >p1->num) && (p1->next!=NULL) )
 {
 p2=p1;
 p1=p1->next;
 }
 if(p0->num <= p1->num)
 {
 if(head ==p1)
 head=p0;
 else
 p2->next=p0;
 p0->next=p1;
 }
 else
 {
 p1->next=p0;
 p0->next=NULL;
 }
 }
 n=n+1;
 return(head);
 
 }
 

 */


/**
 151 链表题：一个链表的结点结构
 struct Node
 {
 int data ;
 Node *next ;
 };
 typedef struct Node Node ;
 
 (1)已知链表的头结点head,写一个函数把这个链表逆序 ( Intel)
 
 Node * ReverseList(Node *head) //链表逆序
 {
 if ( head == NULL || head->next == NULL )
 return head;
 Node *p1 = head ;
 Node *p2 = p1->next ;
 Node *p3 = p2->next ;
 p1->next = NULL ;
 while ( p3 != NULL )
 {
 p2->next = p1 ;
 p1 = p2 ;
 p2 = p3 ;
 p3 = p3->next ;
 }
 p2->next = p1 ;
 head = p2 ;
 return head ;
 }
 (2)已知两个链表head1 和head2 各自有序，请把它们合并成一个链表依然有序。(保留所有结点，即便大小相同）
 
 Node * Merge(Node *head1 , Node *head2)
 {
 if ( head1 == NULL)
 return head2 ;
 if ( head2 == NULL)
 return head1 ;
 Node *head = NULL ;
 Node *p1 = NULL;
 Node *p2 = NULL;
 if ( head1->data < head2->data )
 {
 head = head1 ;
 p1 = head1->next;
 p2 = head2 ;
 }
 else
 {
 head = head2 ;
 p2 = head2->next ;
 p1 = head1 ;
 }
 Node *pcurrent = head ;
 while ( p1 != NULL && p2 != NULL)
 {
 if ( p1->data <= p2->data )
 {
 pcurrent->next = p1 ;
 pcurrent = p1 ;
 p1 = p1->next ;
 }
 else
 {
 pcurrent->next = p2 ;
 pcurrent = p2 ;
 p2 = p2->next ;
 }
 }
 if ( p1 != NULL )
 pcurrent->next = p1 ;
 if ( p2 != NULL )
 pcurrent->next = p2 ;
 return head ;
 }
 (3)已知两个链表head1 和head2 各自有序，请把它们合并成一个链表依然有序，这次要求用递归方法进行。 (Autodesk)
 
 答案：
 Node * MergeRecursive(Node *head1 , Node *head2)
 {
 if ( head1 == NULL )
 return head2 ;
 if ( head2 == NULL)
 return head1 ;
 Node *head = NULL ;
 if ( head1->data < head2->data )
 {
 head = head1 ;
 head->next = MergeRecursive(head1->next,head2);
 }
 else
 {
 head = head2 ;
 head->next = MergeRecursive(head1,head2->next);
 }
 return head ;
 }
 
 */


/**
 152.利用链表实现将两个有序队列A和B合并到有序队列H中，不准增加其他空间。
 
 请提供全一点的程序
 
 以升序为例：
 while(a != NULL && b!= NULL)
 {
 if (a->data < b->data)
 {
 h->data = a->data;
 a = a->next;
 }
 else if (a->data == b->data)
 {
 h->data = a->data;
 a = a->next;
 b = b->next;
 }
 else
 {
 h->data = b->data;
 b = b->next
 }
 h = h->next;
 }
 if (a == NULL)
 {
 while (b != NULL)
 {
 h->data = b->data;
 h = h->next;
 b = b->next;
 }
 }
 else
 {
 while(a != NULL)
 {
 h->data = a->next;
 h = h->next;
 a = a->next;
 }
 }
 

 */


/**
 153单向链表的反转是一个经常被问到的一个面试题，也是一个非常基础的问题。比如一个链表是这样的： 1->2->3->4->5 通过反转后成为5->4->3->2->1。最容易想到的方法遍历一遍链表，利用一个辅助指针，存储遍历过程中当前指针指向的下一个元素，然后将当前节点元素的指针反转后，利用已经存储的指针往后面继续遍历。源代码如下：
 
 struct linka {
 int data;
 linka* next;
 };
 
 void reverse(linka*& head)
 {
 if(head ==NULL)
 return;
 linka*pre, *cur, *ne;
 pre=head;
 cur=head->next;
 while(cur)
 {
 ne = cur->next;
 cur->next = pre;
 pre = cur;
 cur = ne;
 }
 head->next = NULL;
 head = pre;
 }
 
 还有一种利用递归的方法。这种方法的基本思想是在反转当前节点之前先调用递归函数反转后续节点。源代码如下。不过这个方法有一个缺点，就是在反转后的最后一个结点会形成一个环，所以必须将函数的返回的节点的next域置为NULL。因为要改变head指针，所以我用了引用。算法的源代码如下：
 
 linka* reverse(linka* p,linka*& head)
 {
 if(p == NULL || p->next == NULL)
 {
 head=p;
 return p;
 }
 else
 {
 linka* tmp = reverse(p->next,head);
 tmp->next = p;
 return p;
 }
 }
 
 */


/**
 154 对如下双链表
 typedef struct _node
 {
 int iData;
 struct _node *pPrev;
 struct _node *pNext;
 }node;
 a.请写出代码，将noden插入到nodep后。
 b.如果多线程同时访问此链表，需要加锁，请说明以下步骤
 (a)申请内存给n.
 (b)N数据初始化。
 (c)插入
 注意加锁和解锁的时机。
 
 node* insert(node* p, node* n)
 {
 if ((p == NULL) || (n == NULL))
 {
 return NULL;
 }
 
 if (p->pNext != NULL)
 {
 p->pNext->pPrev = n;
 }
 
 n->pPrev = p;
 n->pNext = p->pNext;
 p->pNext = n;
 
 return n;
 }
 
 */


/**
 155、试创建二叉数，并写出常见的几种遍历方式 ?
 #include "stdio.h"
 #include "string.h"
 #include <stdlib.h>
 #define NULL 0
 typedef struct BiTNode{
 char data;
 struct BiTNode *lchild,*rchild;
 }BiTNode,*BiTree;
 
 BiTree Create(BiTree T){
 char ch;
 ch=getchar();
 if(ch=='0')
 T=NULL;
 else{
 if(!(T=(BiTNode *)malloc(sizeof(BiTNode))))
 printf("Error!");
 T->data=ch;
 T->lchild=Create(T->lchild);
 T->rchild=Create(T->rchild);
 }
 return T;
 }
 
 void Preorder(BiTree T){
 if(T){
 printf("%c",T->data);
 Preorder(T->lchild);
 Preorder(T->rchild);
 }
 }//先序遍历
 
 void Inorder(BiTree T){
 if(T){
 Inorder(T->lchild);
 printf("%c",T->data);
 Inorder(T->rchild);
 }
 }//中序遍历
 
 void Postorder(BiTree T){
 if(T){
 Postorder(T->lchild);
 Postorder(T->rchild);
 printf("%c",T->data);
 }
 }//后序遍历
 

 */


/**
 156、 前序遍历输入，如图所示,写出后序遍历输出结果？
 例如二叉树：
 输入序列ABD..EH...CF.I..G..
 输出结果为：?
 
 答案：
 输出结果为：DHEBIFGCA
 */


/**
 不用库函数,用C语言实现将一整型数字转化为字符串★
 方法1：
 int getlen(char *s){
 int n;
 for(n = 0; *s != '\0'; s++)
 n++;
 return n;
 }
 void reverse(char s[])
 {
 int c,i,j;
 for(i = 0,j = getlen(s) - 1; i < j; i++,j--){
 c = s[i];
 s[i] = s[j];
 s[j] = c;
 }
 }
 void itoa(int n,char s[])
 {
 int i,sign;
 if((sign = n) < 0)
 n = -n;
 i = 0;
 do{//以反序生成数字
s[i++] = n%10 + '0';//get next number
}while((n /= 10) > 0);//delete the number

if(sign < 0)
s[i++] = '-';

s[i] = '\0';
reverse(s);
}

方法2:
#include <iostream>
using namespace std;

void itochar(int num);

void itochar(int num)
{
    int i = 0;
    int j ;
    char stra[10];
    char strb[10];
    while ( num )
    {
        stra[i++]=num%10+48;
        num=num/10;
    }
    stra[i] = '\0';
    for( j=0; j < i; j++)
    {
        strb[j] = stra[i-j-1];
    }
    strb[j] = '\0';
    cout<<strb<<endl;
    
}
int main()
{
    int num;
    cin>>num;
    itochar(num);
    return 0;
}

 */
@implementation JJInterview3

@end
