/* 
  test.js
  JJ_Class_Demo

  Created by Jay on 16/4/22.
  Copyright © 2016年 JJ. All rights reserved.
*/


//计算阶乘
var factorial = function(n) {
    if (n < 0)
        return;
    if (n === 0)
        return 1;
    return n * factorial(n - 1)
};