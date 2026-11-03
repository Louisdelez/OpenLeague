package blix.layout
{
   import blix.IDestructible;
   import blix.assets.proxy.IDisplayChild;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.layout.algorithms.CanvasLayout;
   import blix.layout.algorithms.ILayoutAlgorithm;
   import blix.signals.ISignal;
   import blix.view.ILayoutData;
   import blix.view.ILayoutElement;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class LayoutContainerView extends SpriteProxy implements ILayoutContainer
   {
      
      protected var layoutContainer:ILayoutContainer;
      
      public function LayoutContainerView(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.layoutContainer == null)
         {
            this.layoutContainer = new LayoutContainer(this);
         }
         this.layoutContainer.setLayoutAlgorithm(new CanvasLayout());
         this.layoutContainer.getLayoutInvalidated().add(invalidateLayout);
         this.layoutContainer.getEntryAdded().add(this.elementAddedHandler);
         this.layoutContainer.getEntryRemoved().add(this.elementRemovedHandler);
      }
      
      public function getEntryAdded() : ISignal
      {
         return this.layoutContainer.getEntryAdded();
      }
      
      public function getEntryRemoved() : ISignal
      {
         return this.layoutContainer.getEntryRemoved();
      }
      
      protected function elementAddedHandler(param1:LayoutContainer, param2:LayoutEntry) : void
      {
         var _loc3_:IDisplayChild = null;
         if(param2.element is IDisplayChild)
         {
            _loc3_ = param2.element as IDisplayChild;
            if(!_loc3_.getIsTimelineChild())
            {
               addChild(_loc3_);
            }
         }
      }
      
      protected function elementRemovedHandler(param1:LayoutContainer, param2:LayoutEntry) : void
      {
         var _loc3_:IDisplayChild = null;
         if(param2.element is IDisplayChild)
         {
            _loc3_ = param2.element as IDisplayChild;
            if(!_loc3_.getIsTimelineChild())
            {
               removeChild(_loc3_);
            }
         }
      }
      
      public function addElement(param1:ILayoutElement, param2:ILayoutData = null) : void
      {
         this.layoutContainer.addElement(param1,param2);
      }
      
      public function addElementAt(param1:ILayoutElement, param2:int, param3:ILayoutData = null) : void
      {
         this.layoutContainer.addElementAt(param1,param2,param3);
      }
      
      public function getElementAt(param1:int) : ILayoutElement
      {
         return this.layoutContainer.getElementAt(param1);
      }
      
      public function getElementIndex(param1:ILayoutElement) : int
      {
         return this.layoutContainer.getElementIndex(param1);
      }
      
      public function removeElement(param1:ILayoutElement) : Boolean
      {
         return this.layoutContainer.removeElement(param1);
      }
      
      public function removeElementAt(param1:int) : Boolean
      {
         return this.layoutContainer.removeElementAt(param1);
      }
      
      public function removeAllElements() : void
      {
         this.layoutContainer.removeAllElements();
      }
      
      public function getLayoutAlgorithm() : ILayoutAlgorithm
      {
         return this.layoutContainer.getLayoutAlgorithm();
      }
      
      public function setLayoutAlgorithm(param1:ILayoutAlgorithm) : void
      {
         this.layoutContainer.setLayoutAlgorithm(param1);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this.layoutContainer.setExplicitSize(param1,param2);
         return new Rectangle(0,0,_loc3_.x,_loc3_.y);
      }
      
      override public function destroy() : void
      {
         if(this.layoutContainer is IDestructible)
         {
            (this.layoutContainer as IDestructible).destroy();
         }
         super.destroy();
      }
   }
}

