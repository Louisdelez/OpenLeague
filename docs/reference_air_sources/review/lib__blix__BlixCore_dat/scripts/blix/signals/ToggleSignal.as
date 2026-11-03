package blix.signals
{
   public class ToggleSignal extends Signal implements IToggleSignal
   {
      
      private var _isToggled:Boolean;
      
      private var _valueObjects:Array;
      
      public function ToggleSignal()
      {
         super();
      }
      
      public function getIsToggled() : Boolean
      {
         return this._isToggled;
      }
      
      override public function addItem(param1:ListenerListItem) : void
      {
         var _loc2_:uint = 0;
         if(this._isToggled)
         {
            _loc2_ = this._valueObjects.length;
            if(_loc2_ == 0 || !param1.forceParams && param1.func.length == 0)
            {
               param1.func();
            }
            else if(_loc2_ == 1)
            {
               param1.func(this._valueObjects[0]);
            }
            else
            {
               param1.func.apply(null,this._valueObjects);
            }
         }
         else
         {
            super.addItem(param1);
         }
      }
      
      override protected function registerListener(param1:Function, param2:Boolean, param3:Boolean) : ListenerListItem
      {
         var _loc4_:uint = 0;
         if(this._isToggled)
         {
            _loc4_ = this._valueObjects.length;
            if(_loc4_ == 0 || !param3 && param1.length == 0)
            {
               param1();
            }
            else if(_loc4_ == 1)
            {
               param1(this._valueObjects[0]);
            }
            else
            {
               param1.apply(null,this._valueObjects);
            }
            return super.registerListener(param1,param2,param3);
         }
         return super.registerListener(param1,param2,param3);
      }
      
      override public function dispatch(... rest) : void
      {
         if(this._isToggled)
         {
            return;
         }
         this._isToggled = true;
         this._valueObjects = rest;
         super.dispatch.apply(null,rest);
      }
      
      public function toggleOn(... rest) : void
      {
         this.dispatch(rest);
      }
      
      public function toggleOff() : void
      {
         this._isToggled = false;
         this._valueObjects = null;
      }
   }
}

