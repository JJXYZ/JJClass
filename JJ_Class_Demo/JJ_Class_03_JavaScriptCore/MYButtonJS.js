/* 
  MYButtonJS.js
  JJ_Class_Demo

  Created by Jay on 16/4/22.
  Copyright © 2016年 JJ. All rights reserved.
*/




function ClickHandler(button, callback) {
    this.button = button;
    this.button.onClickHandler = this;
    this.handleEvent = callback;
    
    console.log("OC setOnClickHandler");
};