package spark.components
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.LayoutDirection;
   import mx.core.UIComponent;
   import mx.managers.PopUpManager;
   import mx.styles.ISimpleStyleClient;
   import mx.utils.MatrixUtil;
   import mx.utils.PopUpUtil;
   
   [DefaultProperty("popUp")]
   public class PopUpAnchor extends UIComponent
   {
      
      private static var decomposition:Vector.<Number> = new <Number>[0,0,0,0,0];
      
      private var popUpWidth:Number = 0;
      
      private var popUpHeight:Number = 0;
      
      private var popUpIsDisplayed:Boolean = false;
      
      private var addedToStage:Boolean = false;
      
      private var popUpSizeCaptured:Boolean = false;
      
      private var _popUpHeightMatchesAnchorHeight:Boolean = false;
      
      private var _popUpWidthMatchesAnchorWidth:Boolean = false;
      
      private var _displayPopUp:Boolean = false;
      
      private var _popUp:IFlexDisplayObject;
      
      private var _popUpPosition:String = "topLeft";
      
      public function PopUpAnchor()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
      }
      
      public function set popUpHeightMatchesAnchorHeight(value:Boolean) : void
      {
         if(this._popUpHeightMatchesAnchorHeight == value)
         {
            return;
         }
         this._popUpHeightMatchesAnchorHeight = value;
         invalidateDisplayList();
      }
      
      public function get popUpHeightMatchesAnchorHeight() : Boolean
      {
         return this._popUpHeightMatchesAnchorHeight;
      }
      
      public function set popUpWidthMatchesAnchorWidth(value:Boolean) : void
      {
         if(this._popUpWidthMatchesAnchorWidth == value)
         {
            return;
         }
         this._popUpWidthMatchesAnchorWidth = value;
         invalidateDisplayList();
      }
      
      public function get popUpWidthMatchesAnchorWidth() : Boolean
      {
         return this._popUpWidthMatchesAnchorWidth;
      }
      
      public function set displayPopUp(value:Boolean) : void
      {
         if(this._displayPopUp == value)
         {
            return;
         }
         this._displayPopUp = value;
         this.addOrRemovePopUp();
      }
      
      public function get displayPopUp() : Boolean
      {
         return this._displayPopUp;
      }
      
      [Bindable("popUpChanged")]
      public function set popUp(value:IFlexDisplayObject) : void
      {
         if(this._popUp == value)
         {
            return;
         }
         this._popUp = value;
         if(this._popUp is ISimpleStyleClient)
         {
            ISimpleStyleClient(this._popUp).styleName = this;
         }
         dispatchEvent(new Event("popUpChanged"));
      }
      
      public function get popUp() : IFlexDisplayObject
      {
         return this._popUp;
      }
      
      [Inspectable(category="General",enumeration="left,right,above,below,center,topLeft",defaultValue="topLeft")]
      public function set popUpPosition(value:String) : void
      {
         if(this._popUpPosition == value)
         {
            return;
         }
         this._popUpPosition = value;
         invalidateDisplayList();
      }
      
      public function get popUpPosition() : String
      {
         return this._popUpPosition;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.applyPopUpTransform(unscaledWidth,unscaledHeight);
      }
      
      public function updatePopUpTransform() : void
      {
         this.applyPopUpTransform(width,height);
      }
      
      protected function calculatePopUpPosition() : Point
      {
         var adjustedPosition:String = null;
         var adjustedRegPoint:Point = null;
         var adjustedBounds:Rectangle = null;
         var sandboxRoot:DisplayObject = systemManager.getSandboxRoot();
         var matrix:Matrix = MatrixUtil.getConcatenatedMatrix(this,sandboxRoot);
         var regPoint:Point = new Point();
         if(!matrix)
         {
            return regPoint;
         }
         var popUpBounds:Rectangle = new Rectangle();
         var popUpAsDisplayObject:DisplayObject = this.popUp as DisplayObject;
         this.determinePosition(this.popUpPosition,popUpAsDisplayObject.width,popUpAsDisplayObject.height,matrix,regPoint,popUpBounds);
         if(Boolean(screen))
         {
            switch(this.popUpPosition)
            {
               case PopUpPosition.BELOW:
                  if(popUpBounds.bottom > screen.bottom)
                  {
                     adjustedPosition = PopUpPosition.ABOVE;
                  }
                  break;
               case PopUpPosition.ABOVE:
                  if(popUpBounds.top < screen.top)
                  {
                     adjustedPosition = PopUpPosition.BELOW;
                  }
                  break;
               case PopUpPosition.LEFT:
                  if(popUpBounds.left < screen.left)
                  {
                     adjustedPosition = PopUpPosition.RIGHT;
                  }
                  break;
               case PopUpPosition.RIGHT:
                  if(popUpBounds.right > screen.right)
                  {
                     adjustedPosition = PopUpPosition.LEFT;
                  }
            }
         }
         if(adjustedPosition != null)
         {
            adjustedRegPoint = new Point();
            adjustedBounds = new Rectangle();
            this.determinePosition(adjustedPosition,popUpAsDisplayObject.width,popUpAsDisplayObject.height,matrix,adjustedRegPoint,adjustedBounds);
            if(Boolean(screen))
            {
               switch(adjustedPosition)
               {
                  case PopUpPosition.BELOW:
                     if(adjustedBounds.bottom > screen.bottom)
                     {
                        adjustedPosition = null;
                     }
                     break;
                  case PopUpPosition.ABOVE:
                     if(adjustedBounds.top < screen.top)
                     {
                        adjustedPosition = null;
                     }
                     break;
                  case PopUpPosition.LEFT:
                     if(adjustedBounds.left < screen.left)
                     {
                        adjustedPosition = null;
                     }
                     break;
                  case PopUpPosition.RIGHT:
                     if(adjustedBounds.right > screen.right)
                     {
                        adjustedPosition = null;
                     }
               }
            }
            if(adjustedPosition != null)
            {
               regPoint = adjustedRegPoint;
               popUpBounds = adjustedBounds;
            }
         }
         MatrixUtil.decomposeMatrix(decomposition,matrix,0,0);
         var concatScaleX:Number = decomposition[3];
         var concatScaleY:Number = decomposition[4];
         if(popUpBounds.top < screen.top)
         {
            regPoint.y += (screen.top - popUpBounds.top) / concatScaleY;
         }
         else if(popUpBounds.bottom > screen.bottom)
         {
            regPoint.y -= (popUpBounds.bottom - screen.bottom) / concatScaleY;
         }
         if(popUpBounds.left < screen.left)
         {
            regPoint.x += (screen.left - popUpBounds.left) / concatScaleX;
         }
         else if(popUpBounds.right > screen.right)
         {
            regPoint.x -= (popUpBounds.right - screen.right) / concatScaleX;
         }
         if(layoutDirection == LayoutDirection.RTL)
         {
            regPoint.x += popUpBounds.width;
         }
         return MatrixUtil.getConcatenatedComputedMatrix(this,sandboxRoot).transformPoint(regPoint);
      }
      
      private function addOrRemovePopUp() : void
      {
         if(!this.addedToStage)
         {
            return;
         }
         if(this.popUp == null)
         {
            return;
         }
         if(DisplayObject(this.popUp).parent == null && this.displayPopUp)
         {
            PopUpManager.addPopUp(this.popUp,this,false);
            if(this.popUp is IUIComponent)
            {
               IUIComponent(this.popUp).owner = this;
            }
            this.popUpIsDisplayed = true;
            if(this.popUp is UIComponent && !this.popUpSizeCaptured)
            {
               this.popUpWidth = UIComponent(this.popUp).explicitWidth;
               this.popUpHeight = UIComponent(this.popUp).explicitHeight;
               UIComponent(this.popUp).validateNow();
               this.popUpSizeCaptured = true;
            }
            this.applyPopUpTransform(width,height);
         }
         else if(DisplayObject(this.popUp).parent != null && this.displayPopUp == false)
         {
            this.removeAndResetPopUp();
         }
      }
      
      private function removeAndResetPopUp() : void
      {
         PopUpManager.removePopUp(this.popUp);
         this.popUpIsDisplayed = false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function determinePosition(placement:String, popUpWidth:Number, popUpHeight:Number, matrix:Matrix, registrationPoint:Point, bounds:Rectangle) : void
      {
         switch(placement)
         {
            case PopUpPosition.BELOW:
               registrationPoint.x = 0;
               registrationPoint.y = unscaledHeight;
               break;
            case PopUpPosition.ABOVE:
               registrationPoint.x = 0;
               registrationPoint.y = -popUpHeight;
               break;
            case PopUpPosition.LEFT:
               registrationPoint.x = -popUpWidth;
               registrationPoint.y = 0;
               break;
            case PopUpPosition.RIGHT:
               registrationPoint.x = unscaledWidth;
               registrationPoint.y = 0;
               break;
            case PopUpPosition.CENTER:
               registrationPoint.x = (unscaledWidth - popUpWidth) / 2;
               registrationPoint.y = (unscaledHeight - popUpHeight) / 2;
               break;
            case PopUpPosition.TOP_LEFT:
         }
         var popUpAsDisplayObject:DisplayObject = this.popUp as DisplayObject;
         var topLeft:Point = registrationPoint.clone();
         var size:Point = MatrixUtil.transformBounds(popUpAsDisplayObject.width,popUpAsDisplayObject.height,matrix,topLeft);
         bounds.left = topLeft.x;
         bounds.top = topLeft.y;
         bounds.width = size.x;
         bounds.height = size.y;
      }
      
      private function applyPopUpTransform(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var w:Number = NaN;
         var h:Number = NaN;
         if(!this.popUpIsDisplayed)
         {
            return;
         }
         if(this.popUp is UIComponent)
         {
            if(this.popUpWidthMatchesAnchorWidth)
            {
               UIComponent(this.popUp).width = unscaledWidth;
            }
            else
            {
               UIComponent(this.popUp).explicitWidth = this.popUpWidth;
            }
            if(this.popUpHeightMatchesAnchorHeight)
            {
               UIComponent(this.popUp).height = unscaledHeight;
            }
            else
            {
               UIComponent(this.popUp).explicitHeight = this.popUpHeight;
            }
         }
         else
         {
            w = this.popUpWidthMatchesAnchorWidth ? unscaledWidth : Number(this.popUp.measuredWidth);
            h = this.popUpHeightMatchesAnchorHeight ? unscaledHeight : Number(this.popUp.measuredHeight);
            this.popUp.setActualSize(w,h);
         }
         var popUpPoint:Point = this.calculatePopUpPosition();
         PopUpUtil.applyPopUpTransform(this,$transform.concatenatedColorTransform,systemManager,this.popUp,popUpPoint);
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         this.addedToStage = true;
         this.addOrRemovePopUp();
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         if(this.popUp != null && DisplayObject(this.popUp).parent != null)
         {
            this.removeAndResetPopUp();
         }
         this.addedToStage = false;
      }
   }
}

