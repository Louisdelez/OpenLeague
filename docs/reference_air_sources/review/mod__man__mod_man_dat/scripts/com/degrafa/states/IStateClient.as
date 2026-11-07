package com.degrafa.states
{
   public interface IStateClient
   {
      
      function get currentState() : String;
      
      function set currentState(param1:String) : void;
   }
}

