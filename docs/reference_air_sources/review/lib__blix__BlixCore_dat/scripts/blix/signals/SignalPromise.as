package blix.signals
{
   public class SignalPromise extends Signal
   {
      
      private var _signalTarget:ISignal;
      
      public function SignalPromise()
      {
         super();
      }
      
      public function getSignalTarget() : ISignal
      {
         return this._signalTarget;
      }
      
      public function setSignalTarget(param1:ISignal) : void
      {
         var _loc2_:ListenerListItem = null;
         var _loc3_:ListenerListItem = null;
         if(this._signalTarget == param1)
         {
            return;
         }
         if(this._signalTarget != null)
         {
            _loc2_ = listeners.getHead();
            while(_loc2_ != null)
            {
               this._signalTarget.removeItem(_loc2_);
               _loc2_ = _loc2_.next;
            }
         }
         this._signalTarget = param1;
         if(this._signalTarget != null)
         {
            _loc3_ = listeners.getHead();
            while(_loc3_ != null)
            {
               this._signalTarget.addItem(_loc3_);
               _loc3_ = _loc3_.next;
            }
            listeners.removeAll();
         }
      }
      
      override public function add(param1:Function, param2:Boolean = false) : ListenerListItem
      {
         if(this._signalTarget != null)
         {
            return this._signalTarget.add(param1,param2);
         }
         return super.add(param1,param2);
      }
      
      override public function addOnce(param1:Function, param2:Boolean = false) : ListenerListItem
      {
         if(this._signalTarget != null)
         {
            return this._signalTarget.addOnce(param1,param2);
         }
         return super.addOnce(param1,param2);
      }
      
      override public function addItem(param1:ListenerListItem) : void
      {
         if(this._signalTarget != null)
         {
            this._signalTarget.addItem(param1);
         }
         else
         {
            super.addItem(param1);
         }
      }
      
      override public function remove(param1:Function) : void
      {
         if(this._signalTarget != null)
         {
            this._signalTarget.remove(param1);
         }
         else
         {
            super.remove(param1);
         }
      }
      
      override public function removeItem(param1:ListenerListItem) : void
      {
         if(this._signalTarget != null)
         {
            this._signalTarget.removeItem(param1);
         }
         else
         {
            super.removeItem(param1);
         }
      }
      
      override public function removeAll() : void
      {
         if(this._signalTarget != null)
         {
            this._signalTarget.removeAll();
         }
         else
         {
            super.removeAll();
         }
      }
      
      override public function getHasListeners() : Boolean
      {
         if(this._signalTarget != null)
         {
            return this._signalTarget.getHasListeners();
         }
         return super.getHasListeners();
      }
   }
}

