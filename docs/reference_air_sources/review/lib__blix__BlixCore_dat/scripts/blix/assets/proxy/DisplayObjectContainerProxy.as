package blix.assets.proxy
{
   import blix.IDestructible;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.context.IContext;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class DisplayObjectContainerProxy extends InteractiveObjectProxy implements IDisplayContainer
   {
      
      protected var _children:Vector.<IDisplayChild> = new Vector.<IDisplayChild>();
      
      protected var _containerAsset:DisplayObjectContainer;
      
      protected var timelineChildBinding:TimelineChildBindingBranch = new TimelineChildBindingBranch();
      
      public function DisplayObjectContainerProxy(param1:IContext, param2:DisplayObjectContainer = null)
      {
         super(param1,param2);
         this.createChildren();
      }
      
      protected function createChildren() : void
      {
      }
      
      override protected function unconfigureAsset(param1:DisplayObject) : void
      {
         super.unconfigureAsset(param1);
         this.timelineChildBinding.setDisplayObject(null);
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         var _loc2_:IDisplayChild = null;
         var _loc3_:uint = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:uint = 0;
         super.configureAsset(param1);
         if(param1 != null && !(param1 is DisplayObjectContainer))
         {
            throw new ArgumentError("asset must be type DisplayObjectContainer");
         }
         this._containerAsset = param1 as DisplayObjectContainer;
         if(this._containerAsset != null)
         {
            _loc3_ = 0;
            for each(_loc2_ in this._children)
            {
               _loc4_ = _loc2_.getAsset();
               if(_loc4_ != null)
               {
                  _loc5_ = this.findZPosition(_loc3_);
                  if(_loc4_.parent != this._containerAsset)
                  {
                     this._containerAsset.addChildAt(_loc4_,_loc5_);
                  }
                  else if(_loc5_ != this._containerAsset.getChildIndex(_loc4_))
                  {
                     this._containerAsset.setChildIndex(_loc4_,_loc5_);
                  }
               }
               _loc3_++;
            }
         }
         this.timelineChildBinding.setDisplayObject(this._containerAsset);
      }
      
      public function addChild(param1:IDisplayChild) : void
      {
         var _loc4_:uint = 0;
         if(param1.getParentDisplayContainer() != null)
         {
            param1.getParentDisplayContainer().removeChild(param1);
         }
         var _loc2_:int = int(this.findChildIndex(param1.getWeight(),0,this._children.length));
         param1.setParentDisplayContainer(this);
         param1.getAssetChanged().add(this.childAssetChangedHandler);
         param1.getWeightChanged().add(this.childWeightChangedHandler);
         this._children.splice(_loc2_,0,param1);
         var _loc3_:DisplayObject = param1.getAsset();
         if(this._containerAsset != null && _loc3_ != null)
         {
            _loc4_ = this.findZPosition(_loc2_);
            this._containerAsset.addChildAt(_loc3_,_loc4_);
         }
      }
      
      protected function childAssetChangedHandler(param1:IDisplayChild, param2:DisplayObject, param3:DisplayObject) : void
      {
         var _loc4_:int = 0;
         if(param2 != null && param2.parent != null)
         {
            param2.parent.removeChild(param2);
         }
         if(this._containerAsset == null)
         {
            return;
         }
         if(param3 != null)
         {
            _loc4_ = this._children.indexOf(param1);
            this._containerAsset.addChildAt(param3,this.findZPosition(_loc4_));
         }
      }
      
      protected function childWeightChangedHandler(param1:IDisplayChild, param2:Number, param3:Number) : void
      {
         if(this._containerAsset == null || param1.getAsset() == null)
         {
            return;
         }
         var _loc4_:int = this._children.indexOf(param1);
         if(_loc4_ == -1)
         {
            return;
         }
         this._children.splice(_loc4_,1);
         var _loc5_:int = int(this.findChildIndex(param3,0,this._children.length));
         var _loc6_:uint = this.findZPosition(_loc5_);
         if(this._containerAsset.getChildIndex(param1.getAsset()) < _loc6_)
         {
            _loc6_--;
         }
         this._children.splice(_loc5_,0,param1);
         this._containerAsset.setChildIndex(param1.getAsset(),_loc6_);
      }
      
      public function removeChild(param1:IDisplayChild) : Boolean
      {
         var _loc2_:int = this._children.indexOf(param1);
         if(_loc2_ == -1)
         {
            return false;
         }
         param1.getAssetChanged().remove(this.childAssetChangedHandler);
         param1.getWeightChanged().remove(this.childWeightChangedHandler);
         param1.setParentDisplayContainer(null);
         this._children.splice(_loc2_,1);
         var _loc3_:DisplayObject = param1.getAsset();
         if(_loc3_ != null && this._containerAsset != null)
         {
            this._containerAsset.removeChild(_loc3_);
         }
         return true;
      }
      
      public function removeAllChildren() : void
      {
         var _loc1_:IDisplayChild = null;
         var _loc2_:DisplayObject = null;
         for each(_loc1_ in this._children)
         {
            _loc1_.getAssetChanged().remove(this.childAssetChangedHandler);
            _loc1_.getWeightChanged().remove(this.childWeightChangedHandler);
            _loc1_.setParentDisplayContainer(null);
            _loc2_ = _loc1_.getAsset();
            if(_loc2_ != null && this._containerAsset != null)
            {
               this._containerAsset.removeChild(_loc2_);
            }
         }
         this._children.length = 0;
      }
      
      public function getChildren() : Vector.<IDisplayChild>
      {
         return this._children.slice();
      }
      
      protected function findChildIndex(param1:Number, param2:uint, param3:uint) : uint
      {
         if(param3 == param2)
         {
            return param2;
         }
         var _loc4_:uint = (param3 - param2 >> 1) + param2;
         var _loc5_:IDisplayChild = this._children[_loc4_];
         if(param1 < _loc5_.getWeight())
         {
            return this.findChildIndex(param1,param2,_loc4_);
         }
         return this.findChildIndex(param1,_loc4_ + 1,param3);
      }
      
      protected function findZPosition(param1:uint) : uint
      {
         var _loc2_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         if(param1 >= this._children.length)
         {
            return this._containerAsset.numChildren;
         }
         var _loc3_:uint = this._children.length;
         var _loc4_:uint = param1;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._children[_loc4_].getAsset();
            if(_loc5_ != null && _loc5_.parent == this._containerAsset)
            {
               _loc2_ = _loc5_;
               break;
            }
            _loc4_++;
         }
         if(_loc2_ == null)
         {
            return this._containerAsset.numChildren;
         }
         return this._containerAsset.getChildIndex(_loc2_);
      }
      
      public function getTimelineChildren(param1:InstanceMapping) : Vector.<IDisplayChild>
      {
         return this.getTimelineChildrenByName(param1.getName());
      }
      
      public function getTimelineChildrenByName(param1:String) : Vector.<IDisplayChild>
      {
         var _loc2_:TimelineChildBindingLeaf = this.timelineChildBinding.getLeafByPath(param1.split("."));
         return _loc2_.getChildren();
      }
      
      public function setTimelineChild(param1:InstanceMapping, param2:IDisplayChild) : void
      {
         this.setTimelineChildByName(param1.getName(),param2);
      }
      
      public function setTimelineChildByName(param1:String, param2:IDisplayChild) : void
      {
         var _loc3_:TimelineChildBindingLeaf = this.timelineChildBinding.createBranch(param1.split("."));
         _loc3_.addChild(param2);
         param2.setParentDisplayContainer(this);
         param2.setIsTimelineChild(true);
      }
      
      public function deleteTimelineChildByName(param1:String, param2:IDisplayChild) : Boolean
      {
         var _loc3_:Array = param1.split(".");
         var _loc4_:TimelineChildBindingLeaf = this.timelineChildBinding.getLeafByPath(_loc3_);
         var _loc5_:Boolean = _loc4_.removeChild(param2);
         if(!_loc5_)
         {
            return false;
         }
         param2.setIsTimelineChild(false);
         param2.setParentDisplayContainer(null);
         if(_loc4_.getChildren().length == 0)
         {
            this.timelineChildBinding.removeLeafByInstanceName(_loc3_);
         }
         return true;
      }
      
      public function deleteTimelineChildrenByName(param1:String) : Boolean
      {
         var _loc2_:Array = param1.split(".");
         var _loc3_:TimelineChildBindingLeaf = this.timelineChildBinding.getLeafByPath(_loc2_);
         if(_loc3_ == null)
         {
            return false;
         }
         this.timelineChildBinding.removeLeafByInstanceName(_loc2_);
         _loc3_.destroy();
         return true;
      }
      
      public function getTargetInstanceName(param1:DisplayObject) : String
      {
         if(this._containerAsset == null)
         {
            return null;
         }
         var _loc2_:DisplayObject = param1;
         var _loc3_:Vector.<String> = new Vector.<String>();
         while(_loc2_ != null && _loc2_ != this._containerAsset)
         {
            _loc3_.unshift(_loc2_.name);
            _loc2_ = _loc2_.parent;
         }
         return _loc3_.join(".");
      }
      
      public function getChildByInstanceName(param1:String) : DisplayObject
      {
         var _loc5_:String = null;
         if(this._containerAsset == null)
         {
            return null;
         }
         var _loc2_:Array = param1.split(".");
         var _loc3_:String = _loc2_.pop();
         var _loc4_:DisplayObjectContainer = this._containerAsset;
         for each(_loc5_ in _loc2_)
         {
            _loc4_ = _loc4_.getChildByName(_loc5_) as DisplayObjectContainer;
            if(_loc4_ == null)
            {
               return null;
            }
         }
         return _loc4_.getChildByName(_loc3_);
      }
      
      public function getContainerAsset() : DisplayObjectContainer
      {
         return this._containerAsset;
      }
      
      public function getTabChildren() : Boolean
      {
         return assetProxy.tabChildren;
      }
      
      public function setTabChildren(param1:Boolean) : void
      {
         assetProxy.tabChildren = param1;
      }
      
      public function getMouseChildren() : Boolean
      {
         return assetProxy.mouseChildren;
      }
      
      public function setMouseChildren(param1:Boolean) : void
      {
         assetProxy.mouseChildren = param1;
      }
      
      override public function destroy() : void
      {
         var _loc1_:IDisplayChild = null;
         super.destroy();
         for each(_loc1_ in this._children)
         {
            if(_loc1_ is IDestructible)
            {
               (_loc1_ as IDestructible).destroy();
            }
         }
         this.timelineChildBinding.destroyAllChildren();
         this.timelineChildBinding.destroy();
      }
   }
}

