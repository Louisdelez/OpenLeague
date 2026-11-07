package com.degrafa.decorators
{
   import com.degrafa.geometry.command.CommandStack;
   
   public interface IDecorator
   {
      
      function initialize(param1:CommandStack) : void;
      
      function end(param1:CommandStack) : void;
   }
}

