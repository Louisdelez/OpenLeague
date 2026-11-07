package com.riotgames.platform.gameclient.controllers.game.toMove.components
{
   import com.riotgames.platform.common.ImagePackLookup;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.containers.Canvas;
   import mx.controls.Image;
   import mx.core.UIComponentDescriptor;
   import mx.core.Window;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.CursorManager;
   import mx.styles.*;
   
   public class DialogFrame extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _showGripper:Boolean = false;
      
      private var _553296911dialogFrameBL:Canvas;
      
      private var leftBorder:int = 35;
      
      private var _553297469dialogFrameTL:Canvas;
      
      private var _3152br:int = 70;
      
      private var _503297936dialogFrameBottom:Canvas;
      
      private var bottomBorder:int = 25;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      private var _3136bb:int = 32;
      
      private var rightBorder:int = 35;
      
      private var _27646448dialogFrameTop:Canvas;
      
      private var _857288020dialogFrameLeft:Canvas;
      
      public var _DialogFrame_Image1:Image;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _575749dialogFrame:Canvas;
      
      private var _522512826dialogFrameCenter:Canvas;
      
      private var _2144232107resizable:Boolean;
      
      private var _3154bt:int = 30;
      
      private var _1485313835xOffset:int = 0;
      
      private var _3146bl:int = 70;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      private var _553296917dialogFrameBR:Canvas;
      
      private var topBorder:int = 25;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _553297475dialogFrameTR:Canvas;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"dialogFrame",
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "percentWidth":100,
                     "percentHeight":100,
                     "mouseEnabled":false,
                     "autoLayout":false,
                     "clipContent":false,
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"dialogFrameTop",
                        "stylesFactory":function():void
                        {
                           this.backgroundSize = "100%";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "y":0
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"dialogFrameBottom",
                        "events":{"mouseDown":"__dialogFrameBottom_mouseDown"},
                        "stylesFactory":function():void
                        {
                           this.backgroundSize = "100%";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"cacheAsBitmap":true};
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"dialogFrameLeft",
                        "events":{"mouseDown":"__dialogFrameLeft_mouseDown"},
                        "stylesFactory":function():void
                        {
                           this.backgroundSize = "100%";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "x":0
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"dialogFrameRight",
                        "events":{"mouseDown":"__dialogFrameRight_mouseDown"},
                        "stylesFactory":function():void
                        {
                           this.backgroundSize = "100%";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"cacheAsBitmap":true};
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"dialogFrameCenter",
                        "stylesFactory":function():void
                        {
                           this.backgroundSize = "100%";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "mouseEnabled":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"dialogFrameTL",
                        "events":{"mouseDown":"__dialogFrameTL_mouseDown"},
                        "stylesFactory":function():void
                        {
                           this.backgroundSize = "100%";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "x":0,
                              "y":0
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"dialogFrameTR",
                        "events":{"mouseDown":"__dialogFrameTR_mouseDown"},
                        "stylesFactory":function():void
                        {
                           this.backgroundSize = "100%";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "y":0
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"dialogFrameBL",
                        "events":{"mouseDown":"__dialogFrameBL_mouseDown"},
                        "stylesFactory":function():void
                        {
                           this.backgroundSize = "100%";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "x":0
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"dialogFrameBR",
                        "events":{"mouseDown":"__dialogFrameBR_mouseDown"},
                        "stylesFactory":function():void
                        {
                           this.backgroundSize = "100%";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"cacheAsBitmap":true};
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"_DialogFrame_Image1",
                        "stylesFactory":function():void
                        {
                           this.bottom = "10";
                           this.right = "10";
                        }
                     })]
                  };
               }
            })]};
         }
      });
      
      private var _800463849dialogFrameRight:Canvas;
      
      public function DialogFrame()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.mouseEnabled = false;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("creationComplete",this.___DialogFrame_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         DialogFrame._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get dialogFrame() : Canvas
      {
         return this._575749dialogFrame;
      }
      
      public function set dialogFrame(param1:Canvas) : void
      {
         var _loc2_:Object = this._575749dialogFrame;
         if(_loc2_ !== param1)
         {
            this._575749dialogFrame = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dialogFrame",_loc2_,param1));
         }
      }
      
      public function __dialogFrameTR_mouseDown(param1:MouseEvent) : void
      {
         this.onResizeHandleMouseDown(param1,NativeWindowResize.TOP_RIGHT);
      }
      
      public function get innerWidth() : int
      {
         return this.width - this.leftBorder - this.rightBorder;
      }
      
      private function _DialogFrame_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.xOffset;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogT");
         _loc1_ = this.bl;
         _loc1_ = this.bt;
         _loc1_ = this.dialogFrame.width - (this.bl + this.br);
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogB");
         _loc1_ = this.bl;
         _loc1_ = this.dialogFrame.height - this.bb;
         _loc1_ = this.bb;
         _loc1_ = this.dialogFrame.width - (this.bl + this.br);
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogL");
         _loc1_ = this.bt;
         _loc1_ = this.bl;
         _loc1_ = this.dialogFrame.height - (this.bt + this.bb);
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogR");
         _loc1_ = this.dialogFrame.width - this.br;
         _loc1_ = this.bt;
         _loc1_ = this.br;
         _loc1_ = this.dialogFrame.height - (this.bt + this.bb);
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogC");
         _loc1_ = this.bl;
         _loc1_ = this.bt;
         _loc1_ = this.dialogFrame.width - (this.bl + this.br);
         _loc1_ = this.dialogFrame.height - (this.bt + this.bb);
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogTL");
         _loc1_ = this.bl;
         _loc1_ = this.bt;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogTR");
         _loc1_ = this.dialogFrame.width - this.br;
         _loc1_ = this.br;
         _loc1_ = this.bt;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogBL");
         _loc1_ = this.dialogFrame.height - this.bb;
         _loc1_ = this.bl;
         _loc1_ = this.bb;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogBR");
         _loc1_ = this.dialogFrame.width - this.br;
         _loc1_ = this.dialogFrame.height - this.bb;
         _loc1_ = this.br;
         _loc1_ = this.bb;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_gripper");
         _loc1_ = this.showGripper;
      }
      
      [Bindable(event="propertyChange")]
      public function get dialogFrameBR() : Canvas
      {
         return this._553296917dialogFrameBR;
      }
      
      [Bindable(event="propertyChange")]
      public function get dialogFrameBL() : Canvas
      {
         return this._553296911dialogFrameBL;
      }
      
      public function ___DialogFrame_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function __dialogFrameBottom_mouseDown(param1:MouseEvent) : void
      {
         this.onResizeHandleMouseDown(param1,NativeWindowResize.BOTTOM);
      }
      
      public function get innerHeight() : int
      {
         return this.height - this.topBorder - this.bottomBorder;
      }
      
      public function get innerTop() : int
      {
         return this.y + this.topBorder;
      }
      
      public function set dialogFrameBottom(param1:Canvas) : void
      {
         var _loc2_:Object = this._503297936dialogFrameBottom;
         if(_loc2_ !== param1)
         {
            this._503297936dialogFrameBottom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dialogFrameBottom",_loc2_,param1));
         }
      }
      
      public function get innerBottom() : int
      {
         return this.y + this.height - this.bottomBorder;
      }
      
      public function set dialogFrameTop(param1:Canvas) : void
      {
         var _loc2_:Object = this._27646448dialogFrameTop;
         if(_loc2_ !== param1)
         {
            this._27646448dialogFrameTop = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dialogFrameTop",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dialogFrameTop() : Canvas
      {
         return this._27646448dialogFrameTop;
      }
      
      private function set _910281955innerHeight(param1:int) : void
      {
      }
      
      public function set dialogFrameBL(param1:Canvas) : void
      {
         var _loc2_:Object = this._553296911dialogFrameBL;
         if(_loc2_ !== param1)
         {
            this._553296911dialogFrameBL = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dialogFrameBL",_loc2_,param1));
         }
      }
      
      public function set dialogFrameRight(param1:Canvas) : void
      {
         var _loc2_:Object = this._800463849dialogFrameRight;
         if(_loc2_ !== param1)
         {
            this._800463849dialogFrameRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dialogFrameRight",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dialogFrameRight() : Canvas
      {
         return this._800463849dialogFrameRight;
      }
      
      public function set dialogFrameBR(param1:Canvas) : void
      {
         var _loc2_:Object = this._553296917dialogFrameBR;
         if(_loc2_ !== param1)
         {
            this._553296917dialogFrameBR = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dialogFrameBR",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get xOffset() : int
      {
         return this._1485313835xOffset;
      }
      
      public function __dialogFrameLeft_mouseDown(param1:MouseEvent) : void
      {
         this.onResizeHandleMouseDown(param1,NativeWindowResize.LEFT);
      }
      
      private function _DialogFrame_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return xOffset;
         },function(param1:Number):void
         {
            dialogFrame.x = param1;
         },"dialogFrame.x");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogT");
         },function(param1:Object):void
         {
            dialogFrameTop.setStyle("backgroundImage",param1);
         },"dialogFrameTop.backgroundImage");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return bl;
         },function(param1:Number):void
         {
            dialogFrameTop.x = param1;
         },"dialogFrameTop.x");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return bt;
         },function(param1:Number):void
         {
            dialogFrameTop.height = param1;
         },"dialogFrameTop.height");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.width - (bl + br);
         },function(param1:Number):void
         {
            dialogFrameTop.width = param1;
         },"dialogFrameTop.width");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogB");
         },function(param1:Object):void
         {
            dialogFrameBottom.setStyle("backgroundImage",param1);
         },"dialogFrameBottom.backgroundImage");
         result[5] = binding;
         binding = new Binding(this,function():Number
         {
            return bl;
         },function(param1:Number):void
         {
            dialogFrameBottom.x = param1;
         },"dialogFrameBottom.x");
         result[6] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.height - bb;
         },function(param1:Number):void
         {
            dialogFrameBottom.y = param1;
         },"dialogFrameBottom.y");
         result[7] = binding;
         binding = new Binding(this,function():Number
         {
            return bb;
         },function(param1:Number):void
         {
            dialogFrameBottom.height = param1;
         },"dialogFrameBottom.height");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.width - (bl + br);
         },function(param1:Number):void
         {
            dialogFrameBottom.width = param1;
         },"dialogFrameBottom.width");
         result[9] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogL");
         },function(param1:Object):void
         {
            dialogFrameLeft.setStyle("backgroundImage",param1);
         },"dialogFrameLeft.backgroundImage");
         result[10] = binding;
         binding = new Binding(this,function():Number
         {
            return bt;
         },function(param1:Number):void
         {
            dialogFrameLeft.y = param1;
         },"dialogFrameLeft.y");
         result[11] = binding;
         binding = new Binding(this,function():Number
         {
            return bl;
         },function(param1:Number):void
         {
            dialogFrameLeft.width = param1;
         },"dialogFrameLeft.width");
         result[12] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.height - (bt + bb);
         },function(param1:Number):void
         {
            dialogFrameLeft.height = param1;
         },"dialogFrameLeft.height");
         result[13] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogR");
         },function(param1:Object):void
         {
            dialogFrameRight.setStyle("backgroundImage",param1);
         },"dialogFrameRight.backgroundImage");
         result[14] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.width - br;
         },function(param1:Number):void
         {
            dialogFrameRight.x = param1;
         },"dialogFrameRight.x");
         result[15] = binding;
         binding = new Binding(this,function():Number
         {
            return bt;
         },function(param1:Number):void
         {
            dialogFrameRight.y = param1;
         },"dialogFrameRight.y");
         result[16] = binding;
         binding = new Binding(this,function():Number
         {
            return br;
         },function(param1:Number):void
         {
            dialogFrameRight.width = param1;
         },"dialogFrameRight.width");
         result[17] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.height - (bt + bb);
         },function(param1:Number):void
         {
            dialogFrameRight.height = param1;
         },"dialogFrameRight.height");
         result[18] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogC");
         },function(param1:Object):void
         {
            dialogFrameCenter.setStyle("backgroundImage",param1);
         },"dialogFrameCenter.backgroundImage");
         result[19] = binding;
         binding = new Binding(this,function():Number
         {
            return bl;
         },function(param1:Number):void
         {
            dialogFrameCenter.x = param1;
         },"dialogFrameCenter.x");
         result[20] = binding;
         binding = new Binding(this,function():Number
         {
            return bt;
         },function(param1:Number):void
         {
            dialogFrameCenter.y = param1;
         },"dialogFrameCenter.y");
         result[21] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.width - (bl + br);
         },function(param1:Number):void
         {
            dialogFrameCenter.width = param1;
         },"dialogFrameCenter.width");
         result[22] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.height - (bt + bb);
         },function(param1:Number):void
         {
            dialogFrameCenter.height = param1;
         },"dialogFrameCenter.height");
         result[23] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogTL");
         },function(param1:Object):void
         {
            dialogFrameTL.setStyle("backgroundImage",param1);
         },"dialogFrameTL.backgroundImage");
         result[24] = binding;
         binding = new Binding(this,function():Number
         {
            return bl;
         },function(param1:Number):void
         {
            dialogFrameTL.width = param1;
         },"dialogFrameTL.width");
         result[25] = binding;
         binding = new Binding(this,function():Number
         {
            return bt;
         },function(param1:Number):void
         {
            dialogFrameTL.height = param1;
         },"dialogFrameTL.height");
         result[26] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogTR");
         },function(param1:Object):void
         {
            dialogFrameTR.setStyle("backgroundImage",param1);
         },"dialogFrameTR.backgroundImage");
         result[27] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.width - br;
         },function(param1:Number):void
         {
            dialogFrameTR.x = param1;
         },"dialogFrameTR.x");
         result[28] = binding;
         binding = new Binding(this,function():Number
         {
            return br;
         },function(param1:Number):void
         {
            dialogFrameTR.width = param1;
         },"dialogFrameTR.width");
         result[29] = binding;
         binding = new Binding(this,function():Number
         {
            return bt;
         },function(param1:Number):void
         {
            dialogFrameTR.height = param1;
         },"dialogFrameTR.height");
         result[30] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogBL");
         },function(param1:Object):void
         {
            dialogFrameBL.setStyle("backgroundImage",param1);
         },"dialogFrameBL.backgroundImage");
         result[31] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.height - bb;
         },function(param1:Number):void
         {
            dialogFrameBL.y = param1;
         },"dialogFrameBL.y");
         result[32] = binding;
         binding = new Binding(this,function():Number
         {
            return bl;
         },function(param1:Number):void
         {
            dialogFrameBL.width = param1;
         },"dialogFrameBL.width");
         result[33] = binding;
         binding = new Binding(this,function():Number
         {
            return bb;
         },function(param1:Number):void
         {
            dialogFrameBL.height = param1;
         },"dialogFrameBL.height");
         result[34] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_blackDialogBR");
         },function(param1:Object):void
         {
            dialogFrameBR.setStyle("backgroundImage",param1);
         },"dialogFrameBR.backgroundImage");
         result[35] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.width - br;
         },function(param1:Number):void
         {
            dialogFrameBR.x = param1;
         },"dialogFrameBR.x");
         result[36] = binding;
         binding = new Binding(this,function():Number
         {
            return dialogFrame.height - bb;
         },function(param1:Number):void
         {
            dialogFrameBR.y = param1;
         },"dialogFrameBR.y");
         result[37] = binding;
         binding = new Binding(this,function():Number
         {
            return br;
         },function(param1:Number):void
         {
            dialogFrameBR.width = param1;
         },"dialogFrameBR.width");
         result[38] = binding;
         binding = new Binding(this,function():Number
         {
            return bb;
         },function(param1:Number):void
         {
            dialogFrameBR.height = param1;
         },"dialogFrameBR.height");
         result[39] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_gripper");
         },function(param1:Object):void
         {
            _DialogFrame_Image1.source = param1;
         },"_DialogFrame_Image1.source");
         result[40] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.showGripper;
         },function(param1:Boolean):void
         {
            _DialogFrame_Image1.visible = param1;
         },"_DialogFrame_Image1.visible");
         result[41] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function set innerWidth(param1:int) : void
      {
         var _loc2_:Object = this.innerWidth;
         if(_loc2_ !== param1)
         {
            this._815887632innerWidth = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"innerWidth",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dialogFrameTL() : Canvas
      {
         return this._553297469dialogFrameTL;
      }
      
      private function set _1183941437innerY(param1:int) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      private function get bb() : int
      {
         return this._3136bb;
      }
      
      [Bindable(event="propertyChange")]
      public function set innerHeight(param1:int) : void
      {
         var _loc2_:Object = this.innerHeight;
         if(_loc2_ !== param1)
         {
            this._910281955innerHeight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"innerHeight",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set innerBottom(param1:int) : void
      {
         var _loc2_:Object = this.innerBottom;
         if(_loc2_ !== param1)
         {
            this._1072481247innerBottom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"innerBottom",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dialogFrameTR() : Canvas
      {
         return this._553297475dialogFrameTR;
      }
      
      [Bindable(event="propertyChange")]
      public function set innerTop(param1:int) : void
      {
         var _loc2_:Object = this.innerTop;
         if(_loc2_ !== param1)
         {
            this._398611231innerTop = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"innerTop",_loc2_,param1));
         }
      }
      
      private function onCreationComplete() : void
      {
         this.recalculateDimensions();
      }
      
      private function set _811272550innerRight(param1:int) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      private function get br() : int
      {
         return this._3152br;
      }
      
      [Bindable(event="propertyChange")]
      private function get bl() : int
      {
         return this._3146bl;
      }
      
      [Bindable(event="propertyChange")]
      private function get bt() : int
      {
         return this._3154bt;
      }
      
      private function set _398611231innerTop(param1:int) : void
      {
      }
      
      private function set _815887632innerWidth(param1:int) : void
      {
      }
      
      public function set dialogFrameLeft(param1:Canvas) : void
      {
         var _loc2_:Object = this._857288020dialogFrameLeft;
         if(_loc2_ !== param1)
         {
            this._857288020dialogFrameLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dialogFrameLeft",_loc2_,param1));
         }
      }
      
      public function __dialogFrameBR_mouseDown(param1:MouseEvent) : void
      {
         this.onResizeHandleMouseDown(param1,NativeWindowResize.BOTTOM_RIGHT);
      }
      
      public function set resizable(param1:Boolean) : void
      {
         var _loc2_:Object = this._2144232107resizable;
         if(_loc2_ !== param1)
         {
            this._2144232107resizable = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"resizable",_loc2_,param1));
         }
      }
      
      public function get innerRight() : int
      {
         return this.x + this.width - this.rightBorder;
      }
      
      public function set xOffset(param1:int) : void
      {
         var _loc2_:Object = this._1485313835xOffset;
         if(_loc2_ !== param1)
         {
            this._1485313835xOffset = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xOffset",_loc2_,param1));
         }
      }
      
      public function set dialogFrameTL(param1:Canvas) : void
      {
         var _loc2_:Object = this._553297469dialogFrameTL;
         if(_loc2_ !== param1)
         {
            this._553297469dialogFrameTL = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dialogFrameTL",_loc2_,param1));
         }
      }
      
      public function set dialogFrameCenter(param1:Canvas) : void
      {
         var _loc2_:Object = this._522512826dialogFrameCenter;
         if(_loc2_ !== param1)
         {
            this._522512826dialogFrameCenter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dialogFrameCenter",_loc2_,param1));
         }
      }
      
      public function get innerLeft() : int
      {
         return this.x + this.leftBorder;
      }
      
      private function set _1072481247innerBottom(param1:int) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function set innerX(param1:int) : void
      {
         var _loc2_:Object = this.innerX;
         if(_loc2_ !== param1)
         {
            this._1183941438innerX = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"innerX",_loc2_,param1));
         }
      }
      
      public function __dialogFrameTL_mouseDown(param1:MouseEvent) : void
      {
         this.onResizeHandleMouseDown(param1,NativeWindowResize.TOP_LEFT);
      }
      
      public function set dialogFrameTR(param1:Canvas) : void
      {
         var _loc2_:Object = this._553297475dialogFrameTR;
         if(_loc2_ !== param1)
         {
            this._553297475dialogFrameTR = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dialogFrameTR",_loc2_,param1));
         }
      }
      
      private function set bb(param1:int) : void
      {
         var _loc2_:Object = this._3136bb;
         if(_loc2_ !== param1)
         {
            this._3136bb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bb",_loc2_,param1));
         }
      }
      
      private function set _675898062showGripper(param1:Boolean) : void
      {
         this._showGripper = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set innerY(param1:int) : void
      {
         var _loc2_:Object = this.innerY;
         if(_loc2_ !== param1)
         {
            this._1183941437innerY = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"innerY",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:DialogFrame = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._DialogFrame_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_toMove_components_DialogFrameWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      private function set bl(param1:int) : void
      {
         var _loc2_:Object = this._3146bl;
         if(_loc2_ !== param1)
         {
            this._3146bl = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bl",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set showGripper(param1:Boolean) : void
      {
         var _loc2_:Object = this.showGripper;
         if(_loc2_ !== param1)
         {
            this._675898062showGripper = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showGripper",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dialogFrameBottom() : Canvas
      {
         return this._503297936dialogFrameBottom;
      }
      
      private function set br(param1:int) : void
      {
         var _loc2_:Object = this._3152br;
         if(_loc2_ !== param1)
         {
            this._3152br = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"br",_loc2_,param1));
         }
      }
      
      private function set bt(param1:int) : void
      {
         var _loc2_:Object = this._3154bt;
         if(_loc2_ !== param1)
         {
            this._3154bt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bt",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get resizable() : Boolean
      {
         return this._2144232107resizable;
      }
      
      private function onResizeHandleMouseDown(param1:MouseEvent, param2:String) : void
      {
         if(!this.resizable)
         {
            return;
         }
         CursorManager.getInstance().removeAllCursors();
         Window(this.parent).nativeWindow.startResize(param2);
      }
      
      private function set _528201859innerLeft(param1:int) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get dialogFrameLeft() : Canvas
      {
         return this._857288020dialogFrameLeft;
      }
      
      public function __dialogFrameRight_mouseDown(param1:MouseEvent) : void
      {
         this.onResizeHandleMouseDown(param1,NativeWindowResize.RIGHT);
      }
      
      [Bindable(event="propertyChange")]
      public function get dialogFrameCenter() : Canvas
      {
         return this._522512826dialogFrameCenter;
      }
      
      private function set _1183941438innerX(param1:int) : void
      {
      }
      
      public function get innerY() : int
      {
         return this.y + this.topBorder;
      }
      
      public function get showGripper() : Boolean
      {
         return this._showGripper;
      }
      
      private function recalculateDimensions() : void
      {
         this.innerX = -1;
         this.innerY = -1;
         this.innerWidth = -1;
         this.innerHeight = -1;
         this.innerTop = -1;
         this.innerLeft = -1;
         this.innerRight = -1;
         this.innerBottom = -1;
      }
      
      [Bindable(event="propertyChange")]
      public function set innerRight(param1:int) : void
      {
         var _loc2_:Object = this.innerRight;
         if(_loc2_ !== param1)
         {
            this._811272550innerRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"innerRight",_loc2_,param1));
         }
      }
      
      public function __dialogFrameBL_mouseDown(param1:MouseEvent) : void
      {
         this.onResizeHandleMouseDown(param1,NativeWindowResize.BOTTOM_LEFT);
      }
      
      public function get innerX() : int
      {
         return this.x + this.leftBorder;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.recalculateDimensions();
      }
      
      [Bindable(event="propertyChange")]
      public function set innerLeft(param1:int) : void
      {
         var _loc2_:Object = this.innerLeft;
         if(_loc2_ !== param1)
         {
            this._528201859innerLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"innerLeft",_loc2_,param1));
         }
      }
   }
}

