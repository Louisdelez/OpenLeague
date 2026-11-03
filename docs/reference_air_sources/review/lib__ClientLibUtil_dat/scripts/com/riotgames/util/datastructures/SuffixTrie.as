package com.riotgames.util.datastructures
{
   public class SuffixTrie
   {
      
      private var _caseSensitive:Boolean;
      
      private var _root:Object;
      
      public function SuffixTrie(param1:Boolean = false)
      {
         super();
         this._caseSensitive = param1;
         this._root = new Object();
      }
      
      public function add(param1:String, param2:Number) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(!this._caseSensitive)
         {
            param1 = param1.toLowerCase();
         }
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            this.insertNodes(param1.substr(_loc3_),param2);
            _loc3_++;
         }
      }
      
      public function find(param1:String) : Array
      {
         if(param1 == null)
         {
            return new Array();
         }
         if(!this._caseSensitive)
         {
            param1 = param1.toLowerCase();
         }
         var _loc2_:Object = this._root;
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = _loc2_[param1.charAt(_loc3_)];
            if(_loc2_ == null)
            {
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != null && _loc2_["indices"] != null)
         {
            return _loc2_["indices"];
         }
         return new Array();
      }
      
      public function remove(param1:Number) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:Queue = new Queue();
         for(_loc3_ in this._root)
         {
            if(_loc3_.length == 1)
            {
               _loc2_.add(this._root[_loc3_]);
            }
         }
         while(Boolean(_loc2_.peek()))
         {
            _loc4_ = _loc2_.poll();
            _loc5_ = _loc4_["indices"] as Array;
            _loc6_ = _loc5_.indexOf(param1);
            if(_loc6_ != -1)
            {
               if(_loc5_.length == 1)
               {
                  delete _loc4_["parent"][_loc4_["name"]];
               }
               else
               {
                  _loc5_.splice(_loc6_,1);
                  for(_loc3_ in _loc4_)
                  {
                     if(_loc3_.length == 1)
                     {
                        _loc2_.add(_loc4_[_loc3_]);
                     }
                  }
               }
            }
         }
      }
      
      private function insertNodes(param1:String, param2:Number) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc3_:Object = this._root;
         var _loc4_:Number = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = _loc3_[param1.charAt(_loc4_)];
            if(_loc5_ == null)
            {
               _loc5_ = new Object();
               _loc5_["indices"] = new Array();
               _loc5_["parent"] = _loc3_;
               _loc5_["name"] = param1.charAt(_loc4_);
               _loc3_[_loc5_["name"]] = _loc5_;
            }
            _loc6_ = _loc5_["indices"] as Array;
            if(_loc6_.indexOf(param2) == -1)
            {
               _loc6_.push(param2);
            }
            _loc3_ = _loc5_;
            _loc4_++;
         }
      }
   }
}

