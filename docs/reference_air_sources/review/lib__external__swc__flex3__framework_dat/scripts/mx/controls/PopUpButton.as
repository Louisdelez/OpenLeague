package mx.controls
{
   import flash.display.DisplayObject;
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
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IRectangularBorder;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.effects.Tween;
   import mx.events.DropdownEvent;
   import mx.events.FlexMouseEvent;
   import mx.events.InterManagerRequest;
   import mx.events.ListEvent;
   import mx.events.MenuEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.styles.ISimpleStyleClient;
   
   use namespace mx_internal;
   
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
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes")]
   [Event(name="open",type="mx.events.DropdownEvent")]
   [Event(name="close",type="mx.events.DropdownEvent")]
   public class PopUpButton extends Button
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var showingPopUp:Boolean = false;
      
      private var popUpIconChanged:Boolean = false;
      
      private var _openAlways:Boolean = false;
      
      private var inTween:Boolean = false;
      
      private var popUpChanged:Boolean = false;
      
      private var _popUp:IUIComponent = null;
      
      private var _closeOnActivity:Boolean = true;
      
      private var tween:Tween = null;
      
      private var arrowButtonsWidth:Number = 0;
      
      private var arrowButtonsHeight:Number = 0;
      
      public function PopUpButton()
      {
         super();
         addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
         addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
      }
      
      override protected function rollOutHandler(event:MouseEvent) : void
      {
         if(overArrowButton(event))
         {
            phase = "up";
            viewSkin();
            return;
         }
         super.rollOutHandler(event);
      }
      
      override protected function mouseUpHandler(event:MouseEvent) : void
      {
         if(overArrowButton(event))
         {
            phase = "arrowOver";
            viewSkin();
            return;
         }
         super.mouseUpHandler(event);
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         var target:Menu = null;
         if(showingPopUp && Boolean(_popUp))
         {
            if(!event.relatedObject)
            {
               close();
            }
            else if(event.relatedObject is Menu)
            {
               target = Menu(event.relatedObject);
               while(Boolean(target.parentMenu))
               {
                  target = target.parentMenu;
               }
               if(_popUp is DisplayObjectContainer && !DisplayObjectContainer(_popUp).contains(target))
               {
                  close();
               }
            }
            else if(_popUp is DisplayObjectContainer && !DisplayObjectContainer(_popUp).contains(event.relatedObject))
            {
               close();
            }
         }
         super.focusOutHandler(event);
      }
      
      mx_internal function getPopUp() : IUIComponent
      {
         return Boolean(_popUp) ? _popUp : null;
      }
      
      override protected function rollOverHandler(event:MouseEvent) : void
      {
         if(overArrowButton(event))
         {
            phase = "arrowOver";
            viewSkin();
            return;
         }
         super.rollOverHandler(event);
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
               close();
            }
         }
         else if(event is SandboxMouseEvent)
         {
            close();
         }
      }
      
      mx_internal function getUnscaledWidth() : Number
      {
         return unscaledWidth;
      }
      
      public function set popUp(value:IUIComponent) : void
      {
         _popUp = value;
         popUpChanged = true;
         invalidateProperties();
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         if(overArrowButton(event))
         {
            if(showingPopUp)
            {
               closeWithEvent(event);
            }
            else
            {
               openWithEvent(event);
            }
            event.stopImmediatePropagation();
         }
         else
         {
            super.clickHandler(event);
            if(openAlways)
            {
               if(showingPopUp)
               {
                  closeWithEvent(event);
               }
               else
               {
                  openWithEvent(event);
               }
            }
         }
      }
      
      override public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
      
      public function get closeOnActivity() : Boolean
      {
         return _closeOnActivity;
      }
      
      mx_internal function overArrowButton(event:MouseEvent) : Boolean
      {
         return event.localX >= unscaledWidth - arrowButtonsWidth;
      }
      
      [Inspectable(environment="none")]
      override public function set toggle(value:Boolean) : void
      {
      }
      
      override mx_internal function getCurrentIconName() : String
      {
         var iconName:String = super.mx_internal::getCurrentIconName();
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
      
      private function displayPopUp(show:Boolean) : void
      {
         var initY:Number = NaN;
         var endY:Number = NaN;
         var easingFunction:Function = null;
         var duration:Number = NaN;
         var screen:Rectangle = null;
         var request:InterManagerRequest = null;
         if(!initialized || show == showingPopUp)
         {
            return;
         }
         var popUpGap:Number = getStyle("popUpGap");
         var point:Point = new Point(0,unscaledHeight + popUpGap);
         point = localToGlobal(point);
         var sm:ISystemManager = systemManager.topLevelSystemManager;
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         if(sm != sbRoot)
         {
            request = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"getVisibleApplicationRect");
            sbRoot.dispatchEvent(request);
            screen = Rectangle(request.value);
         }
         else
         {
            screen = sm.getVisibleApplicationRect();
         }
         if(show)
         {
            if(getPopUp() == null)
            {
               return;
            }
            if(_popUp.parent == null)
            {
               PopUpManager.addPopUp(_popUp,this,false);
               _popUp.owner = this;
            }
            else
            {
               PopUpManager.bringToFront(_popUp);
            }
            if(point.y + _popUp.height > screen.bottom && point.y > screen.top + height + _popUp.height)
            {
               point.y -= unscaledHeight + _popUp.height + 2 * popUpGap;
               initY = -_popUp.height;
            }
            else
            {
               initY = Number(_popUp.height);
            }
            point.x = Math.min(point.x,screen.right - _popUp.getExplicitOrMeasuredWidth());
            point.x = Math.max(point.x,0);
            point = _popUp.parent.globalToLocal(point);
            if(_popUp.x != point.x || _popUp.y != point.y)
            {
               _popUp.move(point.x,point.y);
            }
            _popUp.scrollRect = new Rectangle(0,initY,_popUp.width,_popUp.height);
            if(!_popUp.visible)
            {
               _popUp.visible = true;
            }
            endY = 0;
            showingPopUp = show;
            duration = getStyle("openDuration");
            easingFunction = getStyle("openEasingFunction") as Function;
         }
         else
         {
            showingPopUp = show;
            if(_popUp.parent == null)
            {
               return;
            }
            point = _popUp.parent.globalToLocal(point);
            endY = point.y + _popUp.height > screen.bottom && point.y > screen.top + height + _popUp.height ? -_popUp.height - 2 : _popUp.height + 2;
            initY = 0;
            duration = getStyle("closeDuration");
            easingFunction = getStyle("closeEasingFunction") as Function;
         }
         inTween = true;
         UIComponentGlobals.layoutManager.validateNow();
         UIComponent.suspendBackgroundProcessing();
         tween = new Tween(this,initY,endY,duration);
         if(easingFunction != null)
         {
            tween.easingFunction = easingFunction;
         }
      }
      
      private function calcArrowButtonSize() : void
      {
         var popUpIcon:IFlexDisplayObject;
         var bm:EdgeMetrics = null;
         var popUpIconClass:Class = null;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            try
            {
               bm = currentSkin["borderMetrics"];
            }
            catch(e:Error)
            {
               bm = new EdgeMetrics(3,3,3,3);
            }
         }
         else if(currentSkin is IRectangularBorder)
         {
            bm = IRectangularBorder(currentSkin).borderMetrics;
         }
         else
         {
            bm = new EdgeMetrics(3,3,3,3);
         }
         popUpIcon = IFlexDisplayObject(getChildByName("popUpIcon"));
         if(!popUpIcon)
         {
            popUpIconClass = Class(getStyle("popUpIcon"));
            popUpIcon = new popUpIconClass();
         }
         arrowButtonsWidth = Math.max(getStyle("arrowButtonWidth"),popUpIcon.width + bm.right + 1);
         arrowButtonsHeight = Math.max(measuredHeight,popUpIcon.height + bm.top + bm.bottom);
      }
      
      mx_internal function onTweenUpdate(value:Number) : void
      {
         _popUp.scrollRect = new Rectangle(0,value,_popUp.width,_popUp.height);
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         if(Boolean(_popUp))
         {
            PopUpManager.removePopUp(_popUp);
            showingPopUp = false;
         }
      }
      
      mx_internal function getUnscaledHeight() : Number
      {
         return unscaledHeight;
      }
      
      mx_internal function getArrowButtonsWidth() : Number
      {
         return arrowButtonsWidth;
      }
      
      override mx_internal function viewIcon() : void
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
      
      private function popUpItemClickHandler(event:Event) : void
      {
         if(_closeOnActivity)
         {
            close();
         }
      }
      
      override mx_internal function viewSkin() : void
      {
         var tempSkinName:String = null;
         var stateName:String = null;
         if(!enabled)
         {
            tempSkinName = "disabledSkin";
            stateName = "disabled";
         }
         else if(phase == "arrowOver")
         {
            tempSkinName = "popUpOverSkin";
            stateName = "popUpOver";
         }
         else if(phase == "arrowDown")
         {
            tempSkinName = "popUpDownSkin";
            stateName = "popUpDown";
         }
         else
         {
            tempSkinName = phase + "Skin";
            stateName = phase;
         }
         viewSkinForPhase(tempSkinName,stateName);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(styleProp == null || styleProp == "styleName" || styleProp.toLowerCase().indexOf("popupicon") != -1)
         {
            popUpIconChanged = true;
            changeSkins();
         }
         if(styleProp == "arrowButtonWidth")
         {
            invalidateSize();
         }
         else if(Boolean(styleProp == "popUpStyleName" && _popUp) && Boolean(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0) && _popUp is ISimpleStyleClient)
         {
            ISimpleStyleClient(_popUp).styleName = getStyle("popUpStyleName");
         }
         super.styleChanged(styleProp);
      }
      
      private function menuHideHandler(event:MenuEvent) : void
      {
         if(event.menu != Menu(_popUp).getRootMenu())
         {
            return;
         }
         showingPopUp = true;
         _popUp.visible = true;
         displayPopUp(false);
      }
      
      override protected function commitProperties() : void
      {
         var sm:ISystemManager = null;
         super.commitProperties();
         if(popUpChanged)
         {
            if(_popUp is IFocusManagerComponent)
            {
               IFocusManagerComponent(_popUp).focusEnabled = false;
            }
            _popUp.cacheAsBitmap = true;
            _popUp.scrollRect = new Rectangle(0,0,0,0);
            if(_popUp is Menu)
            {
               _popUp.addEventListener(MenuEvent.MENU_HIDE,menuHideHandler);
            }
            if(_popUp is IListItemRenderer)
            {
               _popUp.addEventListener(ListEvent.ITEM_CLICK,popUpItemClickHandler);
            }
            _popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,popMouseDownOutsideHandler);
            _popUp.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,popMouseDownOutsideHandler);
            _popUp.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,popMouseDownOutsideHandler);
            _popUp.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,popMouseDownOutsideHandler);
            sm = systemManager.topLevelSystemManager;
            sm.getSandboxRoot().addEventListener(Event.RESIZE,stage_resizeHandler,false,0,true);
            _popUp.owner = this;
            if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0 && _popUp is ISimpleStyleClient)
            {
               ISimpleStyleClient(_popUp).styleName = getStyle("popUpStyleName");
            }
            popUpChanged = false;
         }
         if(showingPopUp && !enabled)
         {
            close();
         }
      }
      
      public function set closeOnActivity(value:Boolean) : void
      {
         _closeOnActivity = value;
      }
      
      public function open() : void
      {
         openWithEvent(null);
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable(event="popUpChanged")]
      public function get popUp() : IUIComponent
      {
         return _popUp;
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         if(phase == "over" || phase == "arrowOver")
         {
            phase = overArrowButton(event) ? "arrowOver" : "over";
            viewSkin();
         }
      }
      
      mx_internal function get isShowingPopUp() : Boolean
      {
         return showingPopUp;
      }
      
      private function openWithEvent(trigger:Event = null) : void
      {
         var cbde:DropdownEvent = null;
         if(!showingPopUp && enabled)
         {
            displayPopUp(true);
            cbde = new DropdownEvent(DropdownEvent.OPEN);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         calcArrowButtonSize();
         measuredWidth += arrowButtonsWidth;
         measuredHeight = arrowButtonsHeight;
      }
      
      private function closeWithEvent(trigger:Event = null) : void
      {
         var cbde:DropdownEvent = null;
         if(showingPopUp)
         {
            displayPopUp(false);
            cbde = new DropdownEvent(DropdownEvent.CLOSE);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
         }
      }
      
      override mx_internal function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean) : void
      {
         if(!isNaN(explicitWidth) && !isNaN(explicitHeight) || popUpIconChanged)
         {
            calcArrowButtonSize();
            popUpIconChanged = false;
         }
         unscaledWidth -= arrowButtonsWidth;
         super.mx_internal::layoutContents(unscaledWidth,unscaledHeight,offset);
         unscaledWidth += arrowButtonsWidth;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         super.keyDownHandler(event);
         if(event.ctrlKey && event.keyCode == Keyboard.DOWN)
         {
            openWithEvent(event);
            event.stopPropagation();
         }
         else if(event.ctrlKey && event.keyCode == Keyboard.UP || event.keyCode == Keyboard.ESCAPE)
         {
            closeWithEvent(event);
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.ENTER && showingPopUp)
         {
            _popUp.dispatchEvent(event);
            closeWithEvent(event);
            event.stopPropagation();
         }
         else if(showingPopUp && (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN))
         {
            _popUp.dispatchEvent(event);
            event.stopPropagation();
         }
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         if(overArrowButton(event))
         {
            phase = "arrowDown";
            viewSkin();
            return;
         }
         super.mouseDownHandler(event);
      }
      
      mx_internal function onTweenEnd(value:Number) : void
      {
         _popUp.scrollRect = new Rectangle(0,value,_popUp.width,_popUp.height);
         inTween = false;
         UIComponent.resumeBackgroundProcessing();
         if(!showingPopUp)
         {
            _popUp.visible = false;
            _popUp.scrollRect = null;
         }
      }
      
      public function set openAlways(value:Boolean) : void
      {
         _openAlways = value;
      }
      
      private function stage_resizeHandler(event:Event) : void
      {
         _popUp.visible = false;
         close();
      }
      
      public function close() : void
      {
         closeWithEvent(null);
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get openAlways() : Boolean
      {
         return _openAlways;
      }
   }
}

