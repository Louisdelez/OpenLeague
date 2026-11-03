package flash.html
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.system.*;
   
   [API("661")]
   [native(cls="HTMLPopupWindowClass",instance="HTMLPopupWindowObject",methods="IHTMLPopupWindowObject<HTMLPopupWindowObject>",construct="native")]
   public final class HTMLPopupWindow
   {
      
      private static const MIN_POPUP_HEIGHT:uint = 20;
      
      private static const MIN_POPUP_WIDTH:uint = 50;
      
      private static const MAX_POPUP_HEIGHT:uint = 400;
      
      private static const POPUP_WIDTH_DELTA:uint = 16;
      
      private var m_popupWindowWidth:uint;
      
      private var m_ownerHtmlControl:HTMLLoader;
      
      private var m_activePopupWindow:NativeWindow;
      
      private var m_popupContent:XML;
      
      private var m_popupHtmlControl:HTMLLoader;
      
      private var m_allowSelectedItemUpdate:Boolean;
      
      private var m_closePopupWindowIfNeededClosure:Function;
      
      private var m_setDeactivateClosure:Function;
      
      private var m_itemsWidth:Number;
      
      private var m_itemsHeight:Number;
      
      public function HTMLPopupWindow(owner:HTMLLoader, closePopupWindowIfNeededClosure:Function, setDeactivateClosure:Function, computedFontSize:Number)
      {
         super();
         this.m_ownerHtmlControl = owner;
         this.m_closePopupWindowIfNeededClosure = closePopupWindowIfNeededClosure;
         this.m_setDeactivateClosure = setDeactivateClosure;
         this.m_activePopupWindow = null;
         this.m_popupHtmlControl = null;
         this.m_popupWindowWidth = 0;
         this.beginPopulate(computedFontSize);
      }
      
      private function getCSSPropertyAsFloat(element:*, propertyName:String) : Number
      {
         var computedStyle:* = this.m_popupHtmlControl.window.getComputedStyle(element,"");
         return computedStyle.getPropertyCSSValue(propertyName).getFloatValue(this.m_popupHtmlControl.window.CSSPrimitiveValue.CSS_PX);
      }
      
      private function popupClickHandler(itemIndex:int) : void
      {
         if(Boolean(this.m_activePopupWindow))
         {
            this.m_activePopupWindow.removeEventListener(Event.DEACTIVATE,this.onDeactivate);
         }
         this.m_allowSelectedItemUpdate = false;
         if(itemIndex >= 0)
         {
            this.nativeOnItemClicked(itemIndex);
         }
         this.doDismiss();
      }
      
      private function popupItemsRootBorderSize() : Point
      {
         var size:Point = new Point();
         var popupItemsRoot:* = this.m_popupHtmlControl.window.document.getElementById("popupItemsRoot");
         var topBottomBorderWidth:Number = this.getCSSPropertyAsFloat(popupItemsRoot,"border-top-width") + this.getCSSPropertyAsFloat(popupItemsRoot,"border-bottom-width");
         var leftRightBorderWidth:Number = this.getCSSPropertyAsFloat(popupItemsRoot,"border-left-width") + this.getCSSPropertyAsFloat(popupItemsRoot,"border-right-width");
         size.x = leftRightBorderWidth;
         size.y = topBottomBorderWidth;
         return size;
      }
      
      private function clampToActivePopupWindowLimits(width:Number, height:Number) : Rectangle
      {
         var activePopupWindowMinSize:Point = this.m_activePopupWindow.minSize;
         var activePopupWindowMaxSize:Point = this.m_activePopupWindow.maxSize;
         if(width < activePopupWindowMinSize.x)
         {
            width = activePopupWindowMinSize.x;
         }
         if(width > activePopupWindowMaxSize.x)
         {
            width = activePopupWindowMaxSize.x;
         }
         if(height < activePopupWindowMinSize.y)
         {
            height = activePopupWindowMinSize.y;
         }
         if(height > activePopupWindowMaxSize.y)
         {
            height = activePopupWindowMaxSize.y;
         }
         return new Rectangle(0,0,width,height);
      }
      
      private function popupCompleteHandler(evt:Event) : void
      {
         var clampedItemsRect:Rectangle = null;
         var activePopupWindowRect:Rectangle = null;
         if(this.m_popupHtmlControl == null)
         {
            return;
         }
         this.m_popupHtmlControl.window.onClickPopup = this.popupClickHandler;
         var popupItemsRoot:* = this.m_popupHtmlControl.window.document.getElementById("popupItemsRoot");
         this.m_itemsWidth = popupItemsRoot.scrollWidth;
         this.m_itemsHeight = popupItemsRoot.scrollHeight;
         popupItemsRoot.style.position = "static";
         popupItemsRoot.style.left = "auto";
         popupItemsRoot.style.top = "auto";
         if(this.m_itemsHeight > MAX_POPUP_HEIGHT)
         {
            this.m_itemsHeight = MAX_POPUP_HEIGHT;
            if(this.m_itemsWidth > this.m_popupWindowWidth)
            {
               this.m_itemsWidth += POPUP_WIDTH_DELTA;
            }
         }
         if(NativeWindow.isSupported)
         {
            this.m_activePopupWindow.addEventListener(NativeWindowBoundsEvent.RESIZE,this.onResize);
         }
         var borderSize:Point = this.popupItemsRootBorderSize();
         if(this.m_itemsWidth < this.m_popupWindowWidth)
         {
            this.m_itemsWidth = this.m_popupWindowWidth + borderSize.x;
         }
         this.m_itemsHeight += borderSize.y;
         if(NativeWindow.isSupported)
         {
            clampedItemsRect = this.clampToActivePopupWindowLimits(this.m_itemsWidth,this.m_itemsHeight);
            this.m_itemsWidth = clampedItemsRect.width;
            this.m_itemsHeight = clampedItemsRect.height;
         }
         if(Boolean(this.m_activePopupWindow))
         {
            activePopupWindowRect = this.m_activePopupWindow.bounds;
            activePopupWindowRect.width = this.m_itemsWidth;
            activePopupWindowRect.height = this.m_itemsHeight;
            this.m_activePopupWindow.bounds = activePopupWindowRect;
            this.setPopupHtmlControlSize(this.m_activePopupWindow.width,this.m_activePopupWindow.height);
         }
         else
         {
            this.setPopupHtmlControlSize(this.m_itemsWidth,this.m_itemsHeight);
         }
         this.m_popupHtmlControl.window.onClickPopup = this.popupClickHandler;
         this.m_allowSelectedItemUpdate = true;
         if(Boolean(this.m_activePopupWindow))
         {
            this.m_activePopupWindow.visible = true;
            this.m_activePopupWindow.orderToFront();
         }
         if(Boolean(this.m_ownerHtmlControl) && Boolean(this.m_ownerHtmlControl.stage) && Boolean(this.m_ownerHtmlControl.stage.nativeWindow))
         {
            this.m_setDeactivateClosure();
         }
      }
      
      private function show(windowX:int, windowY:int, popupWindowWidth:int) : void
      {
         var screenPopupPos:Point = null;
         var options:NativeWindowInitOptions = null;
         var size:Point = null;
         this.close();
         if(!this.m_ownerHtmlControl.stage)
         {
            return;
         }
         this.m_popupWindowWidth = popupWindowWidth;
         var windowPopupPos:Point = new Point(windowX,windowY);
         if(NativeWindow.isSupported)
         {
            screenPopupPos = this.m_ownerHtmlControl.stage.nativeWindow.globalToScreen(windowPopupPos);
            options = new NativeWindowInitOptions();
            options.systemChrome = NativeWindowSystemChrome.NONE;
            options.type = NativeWindowType.LIGHTWEIGHT;
            options.transparent = false;
            options.minimizable = false;
            options.maximizable = false;
            options.resizable = true;
            this.m_activePopupWindow = new NativeWindow(options);
            this.m_activePopupWindow.x = screenPopupPos.x;
            this.m_activePopupWindow.y = screenPopupPos.y;
            this.m_activePopupWindow.alwaysInFront = true;
            this.nativeModifyActiveWindowMinWidth(this.m_activePopupWindow,MIN_POPUP_WIDTH);
            size = this.m_activePopupWindow.minSize;
            size.y = MIN_POPUP_HEIGHT;
            this.m_activePopupWindow.minSize = size;
         }
         this.m_popupHtmlControl = this.createHTMLLoader();
         if(NativeWindow.isSupported)
         {
            this.m_activePopupWindow.stage.align = "TL";
            this.m_activePopupWindow.stage.scaleMode = "noScale";
            this.m_activePopupWindow.stage.addChild(this.m_popupHtmlControl);
         }
         else
         {
            this.m_popupHtmlControl.paintsDefaultBackground = false;
            this.nativeShowPopupControl();
            this.nativeUpdatePopupControlMatrix();
            this.m_popupHtmlControl.stage.addEventListener("orientationChange",this.onOrientationChange);
         }
         this.m_popupHtmlControl.runtimeApplicationDomain = ApplicationDomain.currentDomain;
         if(NativeWindow.isSupported)
         {
            this.m_activePopupWindow.addEventListener(Event.DEACTIVATE,this.onDeactivate);
         }
         this.m_popupHtmlControl.addEventListener(Event.COMPLETE,this.popupCompleteHandler);
         this.m_popupHtmlControl.placeLoadStringContentInApplicationSandbox = true;
         this.m_popupHtmlControl.loadString(this.m_popupContent.toXMLString());
      }
      
      private function onDeactivate(evt:Event) : void
      {
         this.doDismiss();
      }
      
      private function onResize(evt:NativeWindowBoundsEvent) : void
      {
         this.setPopupHtmlControlSize(evt.afterBounds.width,evt.afterBounds.height);
      }
      
      private function onOrientationChange(evt:Event) : void
      {
         this.setPopupHtmlControlSize(this.m_itemsWidth,this.m_itemsHeight);
         this.nativeUpdatePopupControlMatrix();
      }
      
      private function setPopupHtmlControlSize(width:int, height:int) : *
      {
         var stageHeight:Number = NaN;
         var body:* = undefined;
         var popupItemsRootBorderSize:Point = popupItemsRootBorderSize();
         var popupItemsRoot:* = this.m_popupHtmlControl.window.document.getElementById("popupItemsRoot");
         if(NativeWindow.isSupported)
         {
            popupItemsRoot.style.height = height - popupItemsRootBorderSize.y + "px";
            popupItemsRoot.style.width = width - popupItemsRootBorderSize.x + "px";
            this.m_popupHtmlControl.width = width;
            this.m_popupHtmlControl.height = height;
         }
         else
         {
            popupItemsRoot.style.width = this.m_popupHtmlControl.stage.stageWidth - popupItemsRootBorderSize.x + "px";
            this.m_popupHtmlControl.width = this.m_popupHtmlControl.stage.stageWidth;
            stageHeight = Number(this.m_popupHtmlControl.height = this.m_popupHtmlControl.stage.stageHeight);
            if(height < stageHeight)
            {
               popupItemsRoot.style.height = height - popupItemsRootBorderSize.y + "px";
               popupItemsRoot.style.position = "absolute";
               popupItemsRoot.style.top = (stageHeight - height) / 2 + "px";
               popupItemsRoot.style.webkitBoxShadow = "0px 0px 10px #000000";
               popupItemsRoot.style.border = "1px solid 5a5d5a";
               popupItemsRoot.style.background = "#e7e7e7";
               body = this.m_popupHtmlControl.window.document.body;
               body.style.backgroundColor = "rgba(0, 0, 0, 0.30)";
            }
            else
            {
               popupItemsRoot.style.position = "absolute";
               popupItemsRoot.style.top = "0px";
               popupItemsRoot.style.height = this.m_popupHtmlControl.stage.stageHeight - popupItemsRootBorderSize.y + "px";
            }
         }
      }
      
      private function doDismiss() : void
      {
         this.m_allowSelectedItemUpdate = false;
         if(Boolean(this.m_ownerHtmlControl))
         {
            this.m_closePopupWindowIfNeededClosure();
         }
      }
      
      public function close() : void
      {
         if(Boolean(this.m_popupHtmlControl))
         {
            this.m_allowSelectedItemUpdate = false;
            if(NativeWindow.isSupported)
            {
               if(Boolean(this.m_activePopupWindow))
               {
                  this.m_activePopupWindow.close();
                  this.m_activePopupWindow = null;
               }
            }
            else
            {
               this.m_popupHtmlControl.stage.removeEventListener("orientationChange",this.onOrientationChange);
               this.nativeHidePopupControl();
            }
            this.m_popupHtmlControl = null;
            this.nativeOnPopupClosed();
         }
      }
      
      public function isActive() : Boolean
      {
         return Boolean(this.m_activePopupWindow) && Boolean(this.m_activePopupWindow.active);
      }
      
      private function beginPopulate(computedFontSize:Number) : void
      {
         XML.ignoreComments = false;
         this.m_popupContent = <html>
								<head>
								    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
									<script>
									<!--
										var selectedIndex = -1;
										var prefixForSelectedItem = "Selected";
										var prefixForDiabledItem = "Disabled";

										function updateSelectedIndexJS( itemIndex )
										{
											if ( selectedIndex != -1 )
											{
												var prevSelectedItem = document.getElementById( selectedIndex );
												var prevClassName = prevSelectedItem.className;

												if ( prevClassName.indexOf( prefixForSelectedItem ) == 0 )
												{
													var newClassName = prevClassName.substring( prefixForSelectedItem.length );
													prevSelectedItem.className = newClassName;
													selectedIndex = -1;
												}

											}
											var newSelectedItem = document.getElementById( itemIndex );
											if ( newSelectedItem )
											{
												var newClassName = newSelectedItem.className;
												if ( newClassName.indexOf( prefixForDiabledItem ) == -1 &&
													 newClassName.indexOf( prefixForSelectedItem ) == -1 )
												{
													newClassName = prefixForSelectedItem + newClassName;
													newSelectedItem.className = newClassName;
													selectedIndex = itemIndex;
												}
											}
										}
									-->
									</script>
									<style>
                                    <!--
                                    div {
                                        padding-left: 4px;
                                        padding-right: 4px;
                                        -webkit-user-select: none;
                                        cursor: default;
                                    }
                                    .PopupItem:hover {
                                        background-color:#b5e7ff;
                                    }
                                    .DisabledPopupItem {
                                        color:#aaaaaa;
                                    }
                                    .SelectedPopupItem {
                                        background-color:#84d3ff;
                                    }
                                    .SelectedPopupItem:hover {
                                        background-color:#5ab2ef;
                                    }
                                    .GroupPopupItem {
                                        padding-left:12px;
                                    }
                                    .GroupPopupItem:hover { 
                                        background-color:#b5e7ff;
                                    }
                                    .DisabledGroupPopupItem {
                                        padding-left:12px;
                                        color:#aaaaaa;
                                    }
                                    .SelectedGroupPopupItem {
                                        background-color:#84d3ff;
                                        padding-left:12px;
                                    }
                                    .SelectedGroupPopupItem:hover {
                                        background-color:#5ab2ef;
                                        padding-left:12px;
                                    }
                                    .GroupLabel {
                                        font-weight: bold;
                                    }
                                    .DisabledGroupLabel {
                                        color:#aaaaaa;
                                        font-weight: bold;
                                    }
                                    -->
                                    </style>
								</head>
								<body style="margin:0px; padding:0px; background:red;" onclick="onClickPopup( -1 )">
									<div id="popupItemsRoot" style="border:1px solid #5a5d5a; position: absolute; top: 0; left:0; overflow: auto; background-color:#e7e7e7; padding:0px; margin: 0px;"/>
								</body>
							</html>;
         this.m_popupContent.head.style.appendChild("div { font-size:" + computedFontSize.toString() + "px; }");
      }
      
      private function escapeStringIfNeeded(str:String) : String
      {
         if(!this.nativeHasXMLSerializationBug)
         {
            return str;
         }
         return str.replace(/&/g,"&amp;").replace(/>/g,"&gt;").replace(/</g,"&lt;").replace(/"/g,"&quot;");
      }
      
      private function addOption(optionText:String, itemIndex:int, isSelected:Boolean, isDisabled:Boolean, isChildOfGroup:Boolean) : void
      {
         var newNode:XML = <div id="" style="white-space: nowrap" class="" onclick=""/>;
         newNode.appendChild(this.escapeStringIfNeeded(optionText));
         newNode.@id = itemIndex;
         var cssClassString:String = "";
         if(!isDisabled)
         {
            newNode.@onclick = "onClickPopup( " + itemIndex + " )";
            if(isSelected)
            {
               cssClassString += "Selected";
               this.m_popupContent.head.script.appendChild("selectedIndex = " + itemIndex + ";");
            }
         }
         else
         {
            cssClassString += "Disabled";
         }
         if(isChildOfGroup)
         {
            cssClassString += "Group";
         }
         cssClassString += "PopupItem";
         newNode["class"] = cssClassString;
         this.m_popupContent.body.div.appendChild(newNode);
      }
      
      private function addGroupLabel(optionText:String, itemIndex:int, isDisabled:Boolean) : void
      {
         var newNode:XML = <div class="" onclick=""/>;
         newNode.appendChild(this.escapeStringIfNeeded(optionText));
         var cssClassString:String = "";
         if(isDisabled)
         {
            cssClassString += "Disabled";
         }
         cssClassString += "GroupLabel";
         newNode["class"] = cssClassString;
         this.m_popupContent.body.div.appendChild(newNode);
      }
      
      private function addSeparator(itemIndex:int) : void
      {
         var newNode:XML = <hr/>;
         this.m_popupContent.body.div.appendChild(newNode);
      }
      
      private function updateSelectedItem(itemIndex:int) : void
      {
         var myJsWin:Object = null;
         if(this.m_allowSelectedItemUpdate)
         {
            myJsWin = this.m_popupHtmlControl.window;
            if(Boolean(myJsWin.updateSelectedIndexJS))
            {
               myJsWin.updateSelectedIndexJS(itemIndex);
            }
         }
      }
      
      private native function nativeOnItemClicked(param1:int) : void;
      
      private native function nativeOnPopupClosed() : void;
      
      private native function get nativeHasXMLSerializationBug() : Boolean;
      
      private native function nativeModifyActiveWindowMinWidth(param1:NativeWindow, param2:uint) : void;
      
      private native function createHTMLLoader() : HTMLLoader;
      
      private native function nativeShowPopupControl() : void;
      
      private native function nativeUpdatePopupControlMatrix() : void;
      
      private native function nativeHidePopupControl() : void;
   }
}

