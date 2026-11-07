package org.igniterealtime.xiff.filter
{
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.util.Callback;
   
   public class CallbackPacketFilter implements IPacketFilter
   {
      
      private var _filterFunction:Function;
      
      private var _callback:Callback;
      
      private var _processFunction:Function;
      
      public function CallbackPacketFilter(param1:Callback, param2:Function = null, param3:Function = null)
      {
         super();
         this._callback = param1;
         this._filterFunction = param2;
         this._processFunction = param3;
      }
      
      public function accept(param1:XMPPStanza) : void
      {
         var _loc2_:Object = null;
         if(this._filterFunction == null || Boolean(this._filterFunction(param1)))
         {
            _loc2_ = param1;
            if(this._processFunction != null)
            {
               _loc2_ = this._processFunction(param1);
            }
            this._callback.call(_loc2_);
         }
      }
   }
}

