package com.riotgames.gameItems.action
{
   import blix.action.LoadBytesAction;
   import blix.action.SequenceAction;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class LoadPropertiesBinaryAction extends SequenceAction
   {
      
      private var loadBytesAction:LoadBytesAction;
      
      public var data:Object;
      
      private var propertyMatch:RegExp;
      
      private var valueMatch:RegExp;
      
      public function LoadPropertiesBinaryAction(param1:URLRequest, param2:RegExp = null, param3:RegExp = null, param4:Boolean = false)
      {
         super(param4);
         this.propertyMatch = new RegExp(/tr\s*"(\w*)/);
         this.valueMatch = /\s*"*([^"]+)"/;
         this.loadBytesAction = new LoadBytesAction(param1);
         this.loadBytesAction.getErred().add(this.onLoadBytesActionErred);
         then(this.loadBytesAction);
         thenCall(this.prepData);
      }
      
      private function onLoadBytesActionErred() : void
      {
         abort();
      }
      
      private function prepData() : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc1_:ByteArray = (this.loadBytesAction.loader.content as Object).getColloq();
         var _loc2_:String = _loc1_.readUTFBytes(_loc1_.length);
         var _loc3_:Array = _loc2_.split(/[\r\n]+/);
         this.data = new Object();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.indexOf("[") < 0)
            {
               _loc5_ = _loc4_.split("=");
               if(_loc5_.length == 2)
               {
                  _loc6_ = _loc5_[0].match(this.propertyMatch);
                  if(_loc6_ != null)
                  {
                     _loc7_ = _loc6_.length > 1 ? _loc6_[1] : _loc6_[0];
                     _loc8_ = _loc5_[1].match(this.valueMatch);
                     if(_loc8_ != null)
                     {
                        _loc9_ = _loc8_.length > 1 ? _loc8_[1] : _loc8_[0];
                        this.data[_loc7_] = _loc9_;
                     }
                  }
               }
            }
         }
         completeFunction(this.prepData);
      }
   }
}

