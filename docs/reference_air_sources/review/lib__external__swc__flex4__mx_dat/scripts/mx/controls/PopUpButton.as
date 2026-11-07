package mx.controls
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.core.ILayoutDirectionElement;
   import mx.core.IRectangularBorder;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.effects.Tween;
   import mx.events.DropdownEvent;
   import mx.events.FlexMouseEvent;
   import mx.events.ListEvent;
   import mx.events.MenuEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.styles.ISimpleStyleClient;
   
   [RequiresDataBinding("true")]
   [Exclude(name="selectedUpSkin",kind="style")]
   [Exclude(name="selectedUpIcon",kind="style")]
   [Exclude(name="selectedOverSkin",kind="style")]
   [Exclude(name="selectedOverIcon",kind="style")]
   [Exclude(name="selectedDownSkin",kind="style")]
   [Exclude(name="selectedDownIcon",kind="style")]
   [Exclude(name="selectedDisabledSkin",kind="style")]
   [Exclude(name="selectedDisabledIcon",kind="style")]
   [Exclude(name="toggle",kind="property")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="skin",type="Class",inherit="no",states="up, over, down, disabled, popUpOver, popUpDown")]
   [Style(name="popUpOverSkin",type="Class",inherit="no")]
   [Style(name="popUpIcon",type="Class",inherit="no")]
   [Style(name="popUpGap",type="Number",format="Length",inherit="no")]
   [Style(name="popUpDownSkin",type="Class",inherit="no")]
   [Style(name="popUpStyleName",type="String",inherit="no")]
   [Style(name="openEasingFunction",type="Function",inherit="no")]
   [Style(name="openDuration",type="Number",format="Time",inherit="no")]
   [Style(name="icon",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="closeEasingFunction",type="Function",inherit="no")]
   [Style(name="closeDuration",type="Number",format="Time",inherit="no")]
   [Style(name="arrowButtonWidth",type="Number",format="Length",inherit="no")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Event(name="open",type="mx.events.DropdownEvent")]
   [Event(name="close",type="mx.events.DropdownEvent")]
   public class PopUpButton extends Button
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var inTween:Boolean = false;
      
      private var showingPopUp:Boolean = false;
      
      private var tween:Tween = null;
      
      private var arrowButtonsWidth:Number = 0;
      
      private var arrowButtonsHeight:Number = 0;
      
      private var popUpIconChanged:Boolean = false;
      
      private var popUpChanged:Boolean = false;
      
      private var _closeOnActivity:Boolean = true;
      
      private var _openAlways:Boolean = false;
      
      private var _popUp:IUIComponent = null;
      
      public function PopUpButton()
      {
         super();
         addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
      }
      
      override public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
      
      [Inspectable(environment="none")]
      override public function set toggle(value:Boolean) : void
      {
      }
      
      public function get closeOnActivity() : Boolean
      {
         return this._closeOnActivity;
      }
      
      public function set closeOnActivity(value:Boolean) : void
      {
         this._closeOnActivity = value;
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get openAlways() : Boolean
      {
         return this._openAlways;
      }
      
      public function set openAlways(value:Boolean) : void
      {
         this._openAlways = value;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable(event="popUpChanged")]
      public function get popUp() : IUIComponent
      {
         return this._popUp;
      }
      
      public function set popUp(value:IUIComponent) : void
      {
         this._popUp = value;
         this.popUpChanged = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var sm:ISystemManager = null;
         super.commitProperties();
         if(this.popUpChanged)
         {
            if(this._popUp is IFocusManagerComponent)
            {
               IFocusManagerComponent(this._popUp).focusEnabled = false;
            }
            this._popUp.cacheAsBitmap = true;
            this._popUp.scrollRect = new Rectangle(0,0,0,0);
            if(this._popUp is Menu)
            {
               this._popUp.addEventListener(MenuEvent.MENU_HIDE,this.menuHideHandler);
            }
            if(this._popUp is IListItemRenderer)
            {
               this._popUp.addEventListener(ListEvent.ITEM_CLICK,this.popUpItemClickHandler);
            }
            this._popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,this.popMouseDownOutsideHandler);
            this._popUp.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,this.popMouseDownOutsideHandler);
            this._popUp.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.popMouseDownOutsideHandler);
            this._popUp.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,this.popMouseDownOutsideHandler);
            sm = systemManager.topLevelSystemManager;
            sm.getSandboxRoot().addEventListener(Event.RESIZE,this.stage_resizeHandler,false,0,true);
            this._popUp.owner = this;
            if(this._popUp is ISimpleStyleClient)
            {
               ISimpleStyleClient(this._popUp).styleName = getStyle("popUpStyleName");
            }
            this.popUpChanged = false;
         }
         if(this.showingPopUp && !enabled)
         {
            this.close();
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.calcArrowButtonSize();
         measuredWidth += this.arrowButtonsWidth;
         measuredHeight = this.arrowButtonsHeight;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(styleProp == null || styleProp == "styleName" || styleProp.toLowerCase().indexOf("popupicon") != -1)
         {
            this.popUpIconChanged = true;
            changeSkins();
         }
         if(styleProp == "arrowButtonWidth")
         {
            invalidateSize();
         }
         else if(Boolean(styleProp == "popUpStyleName") && Boolean(this._popUp) && this._popUp is ISimpleStyleClient)
         {
            ISimpleStyleClient(this._popUp).styleName = getStyle("popUpStyleName");
         }
         super.styleChanged(styleProp);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean) : void
      {
         if(!isNaN(explicitWidth) && !isNaN(explicitHeight) || this.popUpIconChanged)
         {
            this.calcArrowButtonSize();
            this.popUpIconChanged = false;
         }
         unscaledWidth -= this.arrowButtonsWidth;
         super.layoutContents(unscaledWidth,unscaledHeight,offset);
         unscaledWidth += this.arrowButtonsWidth;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewSkin() : void
      {
         var tempSkinName:String = null;
         var stateName:String = null;
         if(!enabled)
         {
            tempSkinName = "disabledSkin";
         }
         else if(phase == "arrowOver")
         {
            tempSkinName = "popUpOverSkin";
         }
         else if(phase == "arrowDown")
         {
            tempSkinName = "popUpDownSkin";
         }
         else
         {
            tempSkinName = phase + "Skin";
         }
         viewSkinForPhase(tempSkinName,this.getCurrentButtonState());
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCurrentIconName() : String
      {
         var iconName:String = super.getCurrentIconName();
         if(Boolean(iconName))
         {
            return iconName;
         }
         if(phase == "arrowOver")
         {
            iconName = selected ? selectedOverIconName : overIconName;
         }
         else if(phase == "arrowDown")
         {
            iconName = selected ? selectedDownIconName : downIconName;
         }
         else
         {
            iconName = phase + "Icon";
         }
         return iconName;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewIcon() : void
      {
         var iconName:String = null;
         if(!enabled)
         {
            iconName = "disabledIcon";
         }
         else if(phase == "arrowOver")
         {
            iconName = selected ? selectedOverIconName : overIconName;
         }
         else if(phase == "arrowDown")
         {
            iconName = selected ? selectedDownIconName : downIconName;
         }
         else
         {
            iconName = phase + "Icon";
         }
         viewIconForPhase(iconName);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCurrentButtonState() : String
      {
         _currentButtonState = "";
         if(!enabled)
         {
            _currentButtonState = "disabled";
         }
         else if(phase == "arrowOver")
         {
            _currentButtonState = "popUpOver";
         }
         else if(phase == "arrowDown")
         {
            _currentButtonState = "popUpDown";
         }
         else
         {
            _currentButtonState = phase;
         }
         return _currentButtonState;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getPopUp() : IUIComponent
      {
         return Boolean(this._popUp) ? this._popUp : null;
      }
      
      public function open() : void
      {
         this.openWithEvent(null);
      }
      
      private function openWithEvent(trigger:Event = null) : void
      {
         var cbde:DropdownEvent = null;
         if(!this.showingPopUp && enabled)
         {
            this.displayPopUp(true);
            cbde = new DropdownEvent(DropdownEvent.OPEN);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
         }
      }
      
      public function close() : void
      {
         this.closeWithEvent(null);
      }
      
      private function closeWithEvent(trigger:Event = null) : void
      {
         var cbde:DropdownEvent = null;
         if(this.showingPopUp)
         {
            this.displayPopUp(false);
            cbde = new DropdownEvent(DropdownEvent.CLOSE);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
         }
      }
      
      private function displayPopUp(show:Boolean) : void
      {
         var initY:Number = NaN;
         var endY:Number = NaN;
         var easingFunction:Function = null;
         var duration:Number = NaN;
         if(!initialized || show == this.showingPopUp)
         {
            return;
         }
         if(this.getPopUp() == null)
         {
            return;
         }
         if(this._popUp is ILayoutDirectionElement)
         {
            ILayoutDirectionElement(this._popUp).layoutDirection = layoutDirection;
         }
         var sm:ISystemManager = systemManager.topLevelSystemManager;
         var screen:Rectangle = sm.getVisibleApplicationRect(null,true);
         if(show)
         {
            if(this._popUp.parent == null)
            {
               PopUpManager.addPopUp(this._popUp,this,false);
               this._popUp.owner = this;
            }
            else
            {
               PopUpManager.bringToFront(this._popUp);
            }
         }
         var popUpGap:Number = Number(getStyle("popUpGap"));
         var point:Point = new Point(layoutDirection == "rtl" ? Number(this._popUp.getExplicitOrMeasuredWidth()) : 0,unscaledHeight + popUpGap);
         point = localToGlobal(point);
         if(show)
         {
            if(point.y + this._popUp.height > screen.bottom && point.y > screen.top + height + this._popUp.height)
            {
               point.y -= unscaledHeight + this._popUp.height + 2 * popUpGap;
               initY = -this._popUp.height;
            }
            else
            {
               initY = Number(this._popUp.height);
            }
            point.x = Math.min(point.x,screen.right - this._popUp.getExplicitOrMeasuredWidth());
            point.x = Math.max(point.x,0);
            point = this._popUp.parent.globalToLocal(point);
            if(this._popUp.x != point.x || this._popUp.y != point.y)
            {
               this._popUp.move(point.x,point.y);
            }
            this._popUp.scrollRect = new Rectangle(0,initY,this._popUp.width,this._popUp.height);
            if(!this._popUp.visible)
            {
               this._popUp.visible = true;
            }
            endY = 0;
            this.showingPopUp = show;
            duration = Number(getStyle("openDuration"));
            easingFunction = getStyle("openEasingFunction") as Function;
         }
         else
         {
            this.showingPopUp = show;
            if(this._popUp.parent == null)
            {
               return;
            }
            point = this._popUp.parent.globalToLocal(point);
            endY = point.y + this._popUp.height > screen.bottom && point.y > screen.top + height + this._popUp.height ? -this._popUp.height - 2 : this._popUp.height + 2;
            initY = 0;
            duration = Number(getStyle("closeDuration"));
            easingFunction = getStyle("closeEasingFunction") as Function;
         }
         this.inTween = true;
         UIComponentGlobals.layoutManager.validateNow();
         UIComponent.suspendBackgroundProcessing();
         this.tween = new Tween(this,initY,endY,duration);
         if(easingFunction != null)
         {
            this.tween.easingFunction = easingFunction;
         }
      }
      
      private function calcArrowButtonSize() : void
      {
         var bm:EdgeMetrics = null;
         var popUpIconClass:Class = null;
         if(currentSkin is IRectangularBorder)
         {
            bm = IRectangularBorder(currentSkin).borderMetrics;
         }
         else
         {
            bm = new EdgeMetrics(3,3,3,3);
         }
         var popUpIcon:IFlexDisplayObject = IFlexDisplayObject(getChildByName("popUpIcon"));
         if(!popUpIcon)
         {
            popUpIconClass = Class(getStyle("popUpIcon"));
            popUpIcon = new popUpIconClass();
         }
         this.arrowButtonsWidth = Math.max(getStyle("arrowButtonWidth"),popUpIcon.width + bm.right + 1);
         this.arrowButtonsHeight = Math.max(measuredHeight,popUpIcon.height + bm.top + bm.bottom);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function overArrowButton(event:MouseEvent) : Boolean
      {
         return event.localX >= unscaledWidth - this.arrowButtonsWidth;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenUpdate(value:Number) : void
      {
         this._popUp.scrollRect = new Rectangle(0,value,this._popUp.width,this._popUp.height);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenEnd(value:Number) : void
      {
         this._popUp.scrollRect = new Rectangle(0,value,this._popUp.width,this._popUp.height);
         this.inTween = false;
         UIComponent.resumeBackgroundProcessing();
         if(!this.showingPopUp)
         {
            this._popUp.visible = false;
            this._popUp.scrollRect = null;
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         super.keyDownHandler(event);
         if(event.ctrlKey && event.keyCode == Keyboard.DOWN)
         {
            this.openWithEvent(event);
            event.stopPropagation();
         }
         else if(event.ctrlKey && event.keyCode == Keyboard.UP || event.keyCode == Keyboard.ESCAPE)
         {
            this.closeWithEvent(event);
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.ENTER && this.showingPopUp)
         {
            this._popUp.dispatchEvent(event);
            this.closeWithEvent(event);
            event.stopPropagation();
         }
         else if(this.showingPopUp && (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN))
         {
            this._popUp.dispatchEvent(event);
            event.stopPropagation();
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         var target:Menu = null;
         if(Boolean(this.showingPopUp) && Boolean(this._popUp) && event.target == this)
         {
            if(!event.relatedObject)
            {
               this.close();
            }
            else if(event.relatedObject is Menu)
            {
               target = Menu(event.relatedObject);
               while(Boolean(target.parentMenu))
               {
                  target = target.parentMenu;
               }
               if(this._popUp is DisplayObjectContainer && !DisplayObjectContainer(this._popUp).contains(target))
               {
                  this.close();
               }
            }
            else if(this._popUp is DisplayObjectContainer && !DisplayObjectContainer(this._popUp).contains(event.relatedObject))
            {
               this.close();
            }
         }
         super.focusOutHandler(event);
      }
      
      override protected function rollOverHandler(event:MouseEvent) : void
      {
         if(this.overArrowButton(event))
         {
            phase = "arrowOver";
            this.viewSkin();
            return;
         }
         super.rollOverHandler(event);
      }
      
      override protected function rollOutHandler(event:MouseEvent) : void
      {
         if(this.overArrowButton(event))
         {
            phase = "up";
            this.viewSkin();
            return;
         }
         super.rollOutHandler(event);
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         if(this.overArrowButton(event))
         {
            phase = "arrowDown";
            this.viewSkin();
            return;
         }
         super.mouseDownHandler(event);
      }
      
      override protected function mouseUpHandler(event:MouseEvent) : void
      {
         if(this.overArrowButton(event))
         {
            phase = "arrowOver";
            this.viewSkin();
            return;
         }
         super.mouseUpHandler(event);
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         if(this.overArrowButton(event))
         {
            if(this.showingPopUp)
            {
               this.closeWithEvent(event);
            }
            else
            {
               this.openWithEvent(event);
            }
            event.stopImmediatePropagation();
         }
         else
         {
            super.clickHandler(event);
            if(this.openAlways)
            {
               if(this.showingPopUp)
               {
                  this.closeWithEvent(event);
               }
               else
               {
                  this.openWithEvent(event);
               }
            }
         }
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         if(phase == "over" || phase == "arrowOver")
         {
            phase = this.overArrowButton(event) ? "arrowOver" : "over";
            this.viewSkin();
         }
      }
      
      private function popUpItemClickHandler(event:Event) : void
      {
         if(this._closeOnActivity)
         {
            this.close();
         }
      }
      
      private function menuHideHandler(event:MenuEvent) : void
      {
         if(event.menu != Menu(this._popUp).getRootMenu())
         {
            return;
         }
         this.showingPopUp = true;
         this._popUp.visible = true;
         this.displayPopUp(false);
      }
      
      private function popMouseDownOutsideHandler(event:Event) : void
      {
         var mouseEvent:MouseEvent = null;
         var p:Point = null;
         if(event is MouseEvent)
         {
            mouseEvent = MouseEvent(event);
            p = event.target.localToGlobal(new Point(mouseEvent.localX,mouseEvent.localY));
            if(!hitTestPoint(p.x,p.y,true))
            {
               this.close();
            }
         }
         else if(event is SandboxMouseEvent)
         {
            this.close();
         }
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         if(Boolean(this._popUp))
         {
            PopUpManager.removePopUp(this._popUp);
            this.showingPopUp = false;
         }
      }
      
      private function stage_resizeHandler(event:Event) : void
      {
         this._popUp.visible = false;
         this.close();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get isShowingPopUp() : Boolean
      {
         return this.showingPopUp;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getArrowButtonsWidth() : Number
      {
         return this.arrowButtonsWidth;
      }
   }
}

