package com.riotgames.rust.decorator
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayChild;
   import blix.decorator.IDecoratable;
   import blix.decorator.IDecorator;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class DisplayGraphDecorator implements IDecorator
   {
      
      private var decoratedClass:Class;
      
      public function DisplayGraphDecorator(param1:Class)
      {
         super();
         this.decoratedClass = param1;
      }
      
      public function getDecoratedClass() : Class
      {
         return DisplayObjectProxy;
      }
      
      public function getIsInheritable() : Boolean
      {
         return true;
      }
      
      public function apply(param1:IDecoratable) : void
      {
         var _loc2_:DisplayObjectProxy = param1 as DisplayObjectProxy;
         _loc2_.getAssetChanged().add(this.assetChangedHandler);
         this.assetChangedHandler(_loc2_,null,_loc2_.getAsset());
      }
      
      public function unapply(param1:IDecoratable) : void
      {
         var _loc2_:DisplayObjectProxy = param1 as DisplayObjectProxy;
         this.assetChangedHandler(_loc2_,_loc2_.getAsset(),null);
         _loc2_.getAssetChanged().remove(this.assetChangedHandler);
      }
      
      public function assetChangedHandler(param1:IDisplayChild, param2:DisplayObject, param3:DisplayObject) : void
      {
         if(param2 is DisplayObjectContainer)
         {
            DisplayObjectContainer(param2).removeEventListener(Event.ADDED,this.childAddedHandler);
         }
         if(!param1.getIsTimelineChild())
         {
            if(param3 is DisplayObjectContainer)
            {
               DisplayObjectContainer(param3).addEventListener(Event.ADDED,this.childAddedHandler);
            }
            this.walk(param3);
         }
      }
      
      private function childAddedHandler(param1:Event) : void
      {
         this.walk(param1.target as DisplayObject);
      }
      
      private function walk(param1:DisplayObject) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = [param1];
         while(Boolean(_loc3_ = _loc2_.shift()))
         {
            if(_loc3_ is this.decoratedClass)
            {
               this.decorate(_loc3_);
            }
            else if(_loc3_ is DisplayObjectContainer)
            {
               _loc4_ = _loc3_ as DisplayObjectContainer;
               _loc5_ = uint(_loc4_.numChildren);
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc2_.push(_loc4_.getChildAt(_loc6_));
                  _loc6_++;
               }
            }
         }
      }
      
      protected function decorate(param1:DisplayObject) : void
      {
         throw new Error("The decorate method is abstract.");
      }
   }
}

