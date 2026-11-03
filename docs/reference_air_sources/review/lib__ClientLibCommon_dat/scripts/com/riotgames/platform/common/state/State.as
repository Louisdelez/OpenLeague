package com.riotgames.platform.common.state
{
   import avmplus.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class State implements IState
   {
      
      private var _name:String = null;
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function State(param1:String = null)
      {
         super();
         this._name = param1;
      }
      
      public function onUpdate() : void
      {
      }
      
      public function onEnter() : void
      {
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function destroy() : void
      {
         this.onExit();
      }
      
      public function onExit() : void
      {
      }
   }
}

