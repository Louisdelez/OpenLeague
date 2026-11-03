package com.riotgames.gameItems.action
{
   import blix.action.LoadBytesAction;
   import blix.action.SequenceAction;
   import com.riotgames.util.json.jsonDecode;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class LoadJsonBinaryAction extends SequenceAction
   {
      
      private var loadBytesAction:LoadBytesAction;
      
      public var data:Object;
      
      public var restrictedMapItemData:Dictionary = new Dictionary();
      
      public function LoadJsonBinaryAction(param1:URLRequest, param2:Boolean = false)
      {
         super(param2);
         this.loadBytesAction = new LoadBytesAction(new URLRequest("app:/assets/dataPacks/items/ItemDataPack.swf"));
         then(this.loadBytesAction);
         thenCall(this.prepData);
      }
      
      private function prepData() : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:Vector.<int> = null;
         var _loc1_:ByteArray = (this.loadBytesAction.loader.content as Object).getItemData();
         var _loc2_:String = _loc1_.readUTFBytes(_loc1_.length);
         this.data = jsonDecode(_loc2_);
         var _loc3_:Object = (this.loadBytesAction.loader.content as Object).mapItems;
         for(_loc4_ in _loc3_)
         {
            _loc5_ = int(_loc4_.substr(3));
            _loc6_ = _loc3_[_loc4_];
            _loc7_ = _loc6_.substr(_loc6_.indexOf("[UnpurchasableItemList]") + 24).split("|");
            for each(_loc8_ in _loc7_)
            {
               if(_loc8_.substr(0,1) == "[")
               {
                  break;
               }
               _loc9_ = _loc8_.indexOf("=") + 1;
               _loc10_ = _loc8_.indexOf(";");
               if(_loc10_ == -1)
               {
                  _loc11_ = _loc8_.substring(_loc9_);
               }
               else
               {
                  _loc11_ = _loc8_.substring(_loc9_,_loc10_);
               }
               _loc12_ = int(_loc11_);
               if(_loc11_ != "" && _loc12_ != 0)
               {
                  _loc13_ = this.restrictedMapItemData[_loc12_] as Vector.<int>;
                  if(!_loc13_)
                  {
                     _loc13_ = new Vector.<int>();
                  }
                  if(_loc13_.indexOf(_loc5_) == -1)
                  {
                     _loc13_.push(_loc5_);
                  }
                  this.restrictedMapItemData[_loc12_] = _loc13_;
               }
            }
         }
         completeFunction(this.prepData);
      }
   }
}

