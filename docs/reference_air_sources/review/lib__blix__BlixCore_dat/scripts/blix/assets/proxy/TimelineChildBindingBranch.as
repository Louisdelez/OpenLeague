package blix.assets.proxy
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class TimelineChildBindingBranch extends TimelineChildBindingLeaf
   {
      
      private var _leaves:Dictionary = new Dictionary();
      
      public function TimelineChildBindingBranch()
      {
         super();
      }
      
      override public function setDisplayObject(param1:DisplayObject) : void
      {
         var _loc2_:TimelineChildBindingLeaf = null;
         var _loc3_:String = null;
         var _loc5_:DisplayObject = null;
         if(_displayObject == param1)
         {
            return;
         }
         var _loc4_:DisplayObjectContainer = _displayObject as DisplayObjectContainer;
         if(_loc4_ != null)
         {
            _loc4_.removeEventListener(Event.REMOVED,this.childRemovedHandler);
            _loc4_.removeEventListener(Event.ADDED,this.childAddedHandler);
         }
         super.setDisplayObject(param1);
         var _loc6_:DisplayObjectContainer = _displayObject as DisplayObjectContainer;
         if(_loc6_ != null)
         {
            _loc6_.addEventListener(Event.REMOVED,this.childRemovedHandler);
            _loc6_.addEventListener(Event.ADDED,this.childAddedHandler);
         }
         for(_loc3_ in this._leaves)
         {
            if(_loc6_ == null)
            {
               _loc5_ = null;
            }
            else
            {
               _loc5_ = _loc6_.getChildByName(_loc3_);
            }
            _loc2_ = this._leaves[_loc3_];
            if(_loc2_ != null)
            {
               _loc2_.setDisplayObject(_loc5_);
            }
         }
      }
      
      protected function childRemovedHandler(param1:Event) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         if(_loc2_.parent == null || _loc2_.parent != _displayObject)
         {
            return;
         }
         if(!_loc2_.name || _loc2_.name.substr(0,8) == "instance")
         {
            return;
         }
         var _loc3_:TimelineChildBindingLeaf = this._leaves[_loc2_.name];
         if(_loc3_ != null && _loc3_.getDisplayObject() == _loc2_)
         {
            _loc3_.setDisplayObject(null);
         }
      }
      
      protected function childAddedHandler(param1:Event) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         if(_loc2_.parent == null || _loc2_.parent != _displayObject)
         {
            return;
         }
         if(!_loc2_.name || _loc2_.name.substr(0,8) == "instance")
         {
            return;
         }
         var _loc3_:TimelineChildBindingLeaf = this._leaves[_loc2_.name];
         if(_loc3_ != null && _loc3_.getDisplayObject() != _loc2_)
         {
            _loc3_.setDisplayObject(_loc2_);
         }
      }
      
      public function addLeaf(param1:String, param2:TimelineChildBindingLeaf) : void
      {
         if(!param1 || param1.substr(0,8) == "instance")
         {
            throw new ArgumentError("Invalid instanceName argument: " + param1);
         }
         this._leaves[param1] = param2;
         var _loc3_:DisplayObjectContainer = _displayObject as DisplayObjectContainer;
         var _loc4_:DisplayObject = _loc3_ == null ? null : _loc3_.getChildByName(param1);
         param2.setDisplayObject(_loc4_);
         param2.parent = this;
      }
      
      public function getLeaf(param1:String) : TimelineChildBindingLeaf
      {
         return this._leaves[param1];
      }
      
      public function getLeafByPath(param1:Array) : TimelineChildBindingLeaf
      {
         var _loc5_:TimelineChildBindingLeaf = null;
         var _loc2_:uint = param1.length;
         if(_loc2_ == 0)
         {
            throw new ArgumentError("The instanceNames parameter must have at least one instance name String.");
         }
         var _loc3_:TimelineChildBindingBranch = this;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = _loc3_.getLeaf(param1[_loc4_]);
            if(_loc4_ < _loc2_)
            {
               if(!(_loc5_ is TimelineChildBindingBranch))
               {
                  return null;
               }
               _loc3_ = _loc5_ as TimelineChildBindingBranch;
            }
            _loc4_++;
         }
         return _loc5_;
      }
      
      public function createBranch(param1:Array) : TimelineChildBindingBranch
      {
         var _loc5_:TimelineChildBindingLeaf = null;
         var _loc6_:String = null;
         var _loc2_:uint = param1.length;
         if(_loc2_ == 0)
         {
            throw new ArgumentError("The instanceNames parameter must have at least one instance name String.");
         }
         var _loc3_:TimelineChildBindingBranch = this;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = _loc3_.getLeaf(param1[_loc4_]);
            if(_loc5_ == null)
            {
               _loc5_ = new TimelineChildBindingBranch();
               _loc3_.addLeaf(param1[_loc4_],_loc5_);
            }
            else if(!(_loc5_ is TimelineChildBindingBranch))
            {
               _loc6_ = param1.slice(0,_loc4_).join(".");
               throw new Error("Cannot create a branch at the given destination. The node at: " + _loc6_ + " is not a branch.");
            }
            _loc3_ = _loc5_ as TimelineChildBindingBranch;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function removeLeafByInstanceName(param1:Array) : TimelineChildBindingLeaf
      {
         var _loc2_:TimelineChildBindingLeaf = null;
         if(param1.length == 1)
         {
            return this.removeLeaf(param1[0]);
         }
         _loc2_ = this.getLeafByPath(param1.slice(0,param1.length - 1));
         if(!(_loc2_ is TimelineChildBindingBranch))
         {
            return null;
         }
         return (_loc2_ as TimelineChildBindingBranch).removeLeaf(param1[param1.length - 1]);
      }
      
      public function removeLeaf(param1:String) : TimelineChildBindingLeaf
      {
         var _loc2_:TimelineChildBindingLeaf = this._leaves[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         _loc2_.parent = null;
         delete this._leaves[param1];
         return _loc2_;
      }
      
      override public function destroyAllChildren() : void
      {
         var _loc1_:TimelineChildBindingLeaf = null;
         for each(_loc1_ in this._leaves)
         {
            _loc1_.destroyAllChildren();
         }
         super.destroyAllChildren();
      }
      
      override public function destroy() : void
      {
         var _loc1_:TimelineChildBindingLeaf = null;
         for each(_loc1_ in this._leaves)
         {
            _loc1_.destroy();
         }
         this._leaves = new Dictionary();
         super.destroy();
      }
   }
}

