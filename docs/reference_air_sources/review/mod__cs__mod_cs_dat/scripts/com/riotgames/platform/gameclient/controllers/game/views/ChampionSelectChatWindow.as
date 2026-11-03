package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.controllers.game.toMove.components.CoreChatTextArea;
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
   import mx.controls.Button;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   import mx.utils.StringUtil;
   
   public class ChampionSelectChatWindow extends GradientCanvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const BLUE_GLOW_OVERLAY:Class = ChampionSelectChatWindow_BLUE_GLOW_OVERLAY;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _153044740sendChatMessage_btn:Button;
      
      private var _1648362389textAreaContainer_c:CoreChatTextArea;
      
      private var _1527860658_chatRoom:ChatRoom;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _chatController:ChatController;
      
      private var _1115259087header_c:GradientCanvas;
      
      private var _120713313_chatTitle:String = "";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      private var _12089446header_c_label:Label;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _1061746875textEntry:Canvas;
      
      private var _1599613778chatInput:TextInput;
      
      private var _disabled:Boolean = false;
      
      public var _ChampionSelectChatWindow_Image1:Image;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function ChampionSelectChatWindow()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":GradientCanvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":GradientCanvas,
                  "id":"header_c",
                  "stylesFactory":function():void
                  {
                     this.borderStyle = "none";
                     this.left = "0";
                     this.top = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":25,
                        "horizontalScrollPolicy":"off",
                        "styleName":"blueHeaderBackground",
                        "verticalScrollPolicy":"off",
                        "percentWidth":100,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Label,
                           "id":"header_c_label",
                           "stylesFactory":function():void
                           {
                              this.left = "5";
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"spectatorPanelHeaderText"};
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":CoreChatTextArea,
                  "id":"textAreaContainer_c",
                  "events":{
                     "keyDown":"__textAreaContainer_c_keyDown",
                     "startSpamPenalty":"__textAreaContainer_c_startSpamPenalty",
                     "endSpamPenalty":"__textAreaContainer_c_endSpamPenalty"
                  },
                  "stylesFactory":function():void
                  {
                     this.backgroundAlpha = 0;
                     this.bottom = "35";
                     this.left = "2";
                     this.right = "2";
                     this.top = "27";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"chatDisplay",
                        "cacheAsBitmap":true
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"textEntry",
                  "stylesFactory":function():void
                  {
                     this.bottom = "3";
                     this.left = "3";
                     this.right = "3";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "x":0,
                        "cacheAsBitmap":true,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":TextInput,
                           "id":"chatInput",
                           "events":{"enter":"__chatInput_enter"},
                           "stylesFactory":function():void
                           {
                              this.bottom = "2";
                              this.focusThickness = 0;
                              this.left = "1";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":25,
                                 "maxChars":200,
                                 "styleName":"standard"
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Image,
                           "id":"_ChampionSelectChatWindow_Image1",
                           "stylesFactory":function():void
                           {
                              this.bottom = "1";
                              this.left = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":27,
                                 "maintainAspectRatio":false,
                                 "mouseChildren":false,
                                 "mouseEnabled":false
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Button,
                           "id":"sendChatMessage_btn",
                           "events":{"click":"__sendChatMessage_btn_click"},
                           "stylesFactory":function():void
                           {
                              this.focusThickness = 0;
                              this.right = "-2";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":39,
                                 "styleName":"longButtonBlue",
                                 "width":100,
                                 "y":5,
                                 "buttonMode":true,
                                 "useHandCursor":true
                              };
                           }
                        })]
                     };
                  }
               })]};
            }
         });
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.backgroundAlpha = 0;
            this.borderSides = "left top";
            this.cornerRadius = 2;
         };
         this.horizontalScrollPolicy = "off";
         this.styleName = "blueParchmentTablet";
         this.verticalScrollPolicy = "off";
         this.cacheAsBitmap = true;
         this.addEventListener("creationComplete",this.___ChampionSelectChatWindow_GradientCanvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionSelectChatWindow._watcherSetupUtil = param1;
      }
      
      public function ___ChampionSelectChatWindow_GradientCanvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      public function get sendChatMessage_btn() : Button
      {
         return this._153044740sendChatMessage_btn;
      }
      
      private function clearChatInput() : void
      {
         this.chatInput.htmlText = "";
      }
      
      private function set _chatRoom(param1:ChatRoom) : void
      {
         var _loc2_:Object = this._1527860658_chatRoom;
         if(_loc2_ !== param1)
         {
            this._1527860658_chatRoom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_chatRoom",_loc2_,param1));
         }
      }
      
      private function onMessageWindowKey(param1:KeyboardEvent) : void
      {
         if(!(Boolean(param1.controlKey) || param1.altKey || Boolean(param1.commandKey) || param1.ctrlKey))
         {
            this.focusInput();
         }
      }
      
      public function set sendChatMessage_btn(param1:Button) : void
      {
         var _loc2_:Object = this._153044740sendChatMessage_btn;
         if(_loc2_ !== param1)
         {
            this._153044740sendChatMessage_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sendChatMessage_btn",_loc2_,param1));
         }
      }
      
      public function set textEntry(param1:Canvas) : void
      {
         var _loc2_:Object = this._1061746875textEntry;
         if(_loc2_ !== param1)
         {
            this._1061746875textEntry = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textEntry",_loc2_,param1));
         }
      }
      
      private function set _270940796disabled(param1:Boolean) : void
      {
         this._disabled = param1;
         if(this._disabled)
         {
            this.sendChatMessage_btn.label = RiotResourceLoader.getString("chat_groupChatWindow_sendButton_label_disabled");
            this.sendChatMessage_btn.toolTip = RiotResourceLoader.getString("chat_groupChatWindow_sendButton_tooltip_disabled");
            this.chatInput.styleName = "chatInputDisabled";
         }
         else if(!this._disabled)
         {
            this.sendChatMessage_btn.label = RiotResourceLoader.getString("chat_groupChatWindow_sendButton_label");
            this.sendChatMessage_btn.toolTip = RiotResourceLoader.getString("chat_groupChatWindow_sendButton_tooltip");
            this.chatInput.styleName = "chatInput";
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionSelectChatWindow = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionSelectChatWindow_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_ChampionSelectChatWindowWatcherSetupUtil");
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
      
      public function resetView() : void
      {
      }
      
      public function get chatController() : ChatController
      {
         return this._chatController;
      }
      
      private function _ChampionSelectChatWindow_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = _chatTitle;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            header_c_label.text = param1;
         },"header_c_label.text");
         result[0] = binding;
         binding = new Binding(this,function():ChatRoom
         {
            return _chatRoom;
         },function(param1:ChatRoom):void
         {
            textAreaContainer_c.chatRoom = param1;
         },"textAreaContainer_c.chatRoom");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return sendChatMessage_btn.height;
         },function(param1:Number):void
         {
            textEntry.height = param1;
         },"textEntry.height");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return textEntry.width - sendChatMessage_btn.width;
         },function(param1:Number):void
         {
            chatInput.width = param1;
         },"chatInput.width");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return BLUE_GLOW_OVERLAY;
         },function(param1:Object):void
         {
            _ChampionSelectChatWindow_Image1.source = param1;
         },"_ChampionSelectChatWindow_Image1.source");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return chatInput.width + 2;
         },function(param1:Number):void
         {
            _ChampionSelectChatWindow_Image1.width = param1;
         },"_ChampionSelectChatWindow_Image1.width");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.disabled || textAreaContainer_c.disconnected;
         },function(param1:Boolean):void
         {
            sendChatMessage_btn.enabled = param1;
         },"sendChatMessage_btn.enabled");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("chat_groupChatWindow_sendButton_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            sendChatMessage_btn.label = param1;
         },"sendChatMessage_btn.label");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("chat_groupChatWindow_sendButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            sendChatMessage_btn.toolTip = param1;
         },"sendChatMessage_btn.toolTip");
         result[8] = binding;
         return result;
      }
      
      private function setChatController() : void
      {
         if(Boolean(this.chatController) && Boolean(this.textAreaContainer_c))
         {
            this.textAreaContainer_c.chatController = this.chatController;
            this.textAreaContainer_c.privacyListController = this.chatController.privacyListController;
         }
         else if(this.textAreaContainer_c)
         {
            this.textAreaContainer_c.chatController = null;
            this.textAreaContainer_c.privacyListController = null;
         }
      }
      
      private function chatInput_enterHandler(param1:FlexEvent) : void
      {
         if(StringUtil.trim(this.chatInput.text).length > 0 && !this.disabled)
         {
            this.sendChatMessage();
         }
      }
      
      public function set chatInput(param1:TextInput) : void
      {
         var _loc2_:Object = this._1599613778chatInput;
         if(_loc2_ !== param1)
         {
            this._1599613778chatInput = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatInput",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set chatRoom(param1:ChatRoom) : void
      {
         var _loc2_:Object = this.chatRoom;
         if(_loc2_ !== param1)
         {
            this._1437342803chatRoom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatRoom",_loc2_,param1));
         }
      }
      
      public function set chatController(param1:ChatController) : void
      {
         if(this._chatController == param1)
         {
            return;
         }
         this._chatController = param1;
         this.setChatController();
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c() : GradientCanvas
      {
         return this._1115259087header_c;
      }
      
      private function set _1609627104chatTitle(param1:String) : void
      {
         this._chatTitle = param1;
      }
      
      public function __sendChatMessage_btn_click(param1:MouseEvent) : void
      {
         this.onSendChatMessageButtonClicked(param1);
      }
      
      protected function onCreationComplete() : void
      {
         this.setChatController();
         this.textAreaContainer_c.recreateTextArea(this.systemManager);
      }
      
      [Bindable(event="propertyChange")]
      private function get _chatRoom() : ChatRoom
      {
         return this._1527860658_chatRoom;
      }
      
      [Bindable(event="propertyChange")]
      public function set chatTitle(param1:String) : void
      {
         var _loc2_:Object = this.chatTitle;
         if(_loc2_ !== param1)
         {
            this._1609627104chatTitle = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatTitle",_loc2_,param1));
         }
      }
      
      private function set _chatTitle(param1:String) : void
      {
         var _loc2_:Object = this._120713313_chatTitle;
         if(_loc2_ !== param1)
         {
            this._120713313_chatTitle = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_chatTitle",_loc2_,param1));
         }
      }
      
      private function set _1437342803chatRoom(param1:ChatRoom) : void
      {
         var _loc2_:ChatRoom = this._chatRoom;
         this._chatRoom = param1;
         if(this.chatInput != null)
         {
            this.chatInput.text = "";
         }
      }
      
      public function get chatRoom() : ChatRoom
      {
         return this._chatRoom;
      }
      
      [Bindable(event="propertyChange")]
      public function get textEntry() : Canvas
      {
         return this._1061746875textEntry;
      }
      
      public function initializeView() : void
      {
      }
      
      public function focusInput() : void
      {
         if(Boolean(focusManager) && Boolean(this.chatInput))
         {
            focusManager.setFocus(this.chatInput);
         }
      }
      
      public function set textAreaContainer_c(param1:CoreChatTextArea) : void
      {
         var _loc2_:Object = this._1648362389textAreaContainer_c;
         if(_loc2_ !== param1)
         {
            this._1648362389textAreaContainer_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textAreaContainer_c",_loc2_,param1));
         }
      }
      
      public function get chatTitle() : String
      {
         return this._chatTitle;
      }
      
      public function set header_c(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._1115259087header_c;
         if(_loc2_ !== param1)
         {
            this._1115259087header_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_c",_loc2_,param1));
         }
      }
      
      public function __chatInput_enter(param1:FlexEvent) : void
      {
         this.chatInput_enterHandler(param1);
      }
      
      public function set header_c_label(param1:Label) : void
      {
         var _loc2_:Object = this._12089446header_c_label;
         if(_loc2_ !== param1)
         {
            this._12089446header_c_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_c_label",_loc2_,param1));
         }
      }
      
      private function sendChatMessage() : void
      {
         if(this.chatRoom)
         {
            this.chatRoom.sendMessage(this.chatInput.text);
            callLater(this.clearChatInput);
         }
      }
      
      public function __textAreaContainer_c_endSpamPenalty(param1:Event) : void
      {
         this.disabled = false;
      }
      
      [Bindable(event="propertyChange")]
      public function get chatInput() : TextInput
      {
         return this._1599613778chatInput;
      }
      
      [Bindable(event="propertyChange")]
      public function get textAreaContainer_c() : CoreChatTextArea
      {
         return this._1648362389textAreaContainer_c;
      }
      
      private function onSendChatMessageButtonClicked(param1:MouseEvent) : void
      {
         if(StringUtil.trim(this.chatInput.text).length > 0)
         {
            this.sendChatMessage();
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _chatTitle() : String
      {
         return this._120713313_chatTitle;
      }
      
      public function __textAreaContainer_c_startSpamPenalty(param1:Event) : void
      {
         this.disabled = true;
      }
      
      private function _ChampionSelectChatWindow_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this._chatTitle;
         _loc1_ = this._chatRoom;
         _loc1_ = this.sendChatMessage_btn.height;
         _loc1_ = this.textEntry.width - this.sendChatMessage_btn.width;
         _loc1_ = BLUE_GLOW_OVERLAY;
         _loc1_ = this.chatInput.width + 2;
         _loc1_ = !this.disabled || this.textAreaContainer_c.disconnected;
         _loc1_ = RiotResourceLoader.getString("chat_groupChatWindow_sendButton_label");
         _loc1_ = RiotResourceLoader.getString("chat_groupChatWindow_sendButton_tooltip");
      }
      
      public function __textAreaContainer_c_keyDown(param1:KeyboardEvent) : void
      {
         this.onMessageWindowKey(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c_label() : Label
      {
         return this._12089446header_c_label;
      }
      
      [Bindable(event="propertyChange")]
      public function set disabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.disabled;
         if(_loc2_ !== param1)
         {
            this._270940796disabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disabled",_loc2_,param1));
         }
      }
      
      public function get disabled() : Boolean
      {
         return this._disabled;
      }
   }
}

