package com.riotgames.platform.gameclient.views.Support
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.domain.PlayerComplaint;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.error.MailError;
   import com.riotgames.platform.gameclient.views.game.common.ICancelableDialog;
   import com.riotgames.pvpnet.celebration.enums.ReportReasonConstants;
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
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.ComboBox;
   import mx.controls.Label;
   import mx.controls.Spacer;
   import mx.controls.TextArea;
   import mx.core.ClassFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ReportPlayerView extends GradientCanvas implements ICancelableDialog, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _950117866buttonSubmit:SoundEffectButton;
      
      private var _775134379commentInput:TextArea;
      
      public var gameID:Number;
      
      mx_internal var _watchers:Array;
      
      private var _768661767offences:ComboBox;
      
      private var onSendReport:Signal;
      
      private var onClosed:Signal;
      
      private var _473928780buttonCancel:SoundEffectButton;
      
      private var _985752863player:PlayerParticipantStatsSummary;
      
      private var _1588167045windowClose_btn:Button;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public var _ReportPlayerView_Label1:Label;
      
      public var _ReportPlayerView_Label2:Label;
      
      public var _ReportPlayerView_Label4:Label;
      
      public var _ReportPlayerView_Label5:Label;
      
      private var _944061186summonerCallout:Label;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function ReportPlayerView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":GradientCanvas,
            "propertiesFactory":function():Object
            {
               return {
                  "height":400,
                  "width":500,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":VBox,
                     "stylesFactory":function():void
                     {
                        this.horizontalAlign = "center";
                        this.horizontalCenter = "0";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "y":20,
                           "percentHeight":90,
                           "percentWidth":100,
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":Label,
                              "id":"_ReportPlayerView_Label1",
                              "stylesFactory":function():void
                              {
                                 this.textAlign = "center";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "styleName":"options",
                                    "percentWidth":90
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Label,
                              "id":"_ReportPlayerView_Label2",
                              "stylesFactory":function():void
                              {
                                 this.fontSize = 14;
                                 this.textDecoration = "underline";
                                 this.textAlign = "left";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "styleName":"options",
                                    "percentWidth":90
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Label,
                              "id":"summonerCallout",
                              "stylesFactory":function():void
                              {
                                 this.textAlign = "left";
                                 this.fontSize = 14;
                                 this.paddingTop = -3;
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "styleName":"options",
                                    "percentWidth":90
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Label,
                              "id":"_ReportPlayerView_Label4",
                              "stylesFactory":function():void
                              {
                                 this.fontSize = 14;
                                 this.textDecoration = "underline";
                                 this.textAlign = "left";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "styleName":"options",
                                    "percentWidth":90
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":ComboBox,
                              "id":"offences",
                              "events":{"change":"__offences_change"},
                              "stylesFactory":function():void
                              {
                                 this.fontFamily = "ApplicationFont2";
                                 this.fontSize = 14;
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "height":40,
                                    "styleName":"runeSelectionComboBox",
                                    "percentWidth":80,
                                    "itemRenderer":_ReportPlayerView_ClassFactory1_c(),
                                    "selectedIndex":0,
                                    "tabEnabled":false
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Label,
                              "id":"_ReportPlayerView_Label5",
                              "stylesFactory":function():void
                              {
                                 this.fontSize = 14;
                                 this.textDecoration = "underline";
                                 this.textAlign = "left";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "styleName":"options",
                                    "percentWidth":90
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":TextArea,
                              "id":"commentInput",
                              "stylesFactory":function():void
                              {
                                 this.focusAlpha = 0;
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "styleName":"EditableTextArea",
                                    "percentWidth":80,
                                    "height":80,
                                    "maxChars":500,
                                    "tabEnabled":false,
                                    "wordWrap":true
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Spacer,
                              "propertiesFactory":function():Object
                              {
                                 return {"percentHeight":95};
                              }
                           }),new UIComponentDescriptor({
                              "type":HBox,
                              "stylesFactory":function():void
                              {
                                 this.horizontalAlign = "center";
                                 this.horizontalCenter = "0";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "percentWidth":100,
                                    "percentHeight":100,
                                    "childDescriptors":[new UIComponentDescriptor({
                                       "type":SoundEffectButton,
                                       "id":"buttonSubmit",
                                       "events":{"click":"__buttonSubmit_click"},
                                       "propertiesFactory":function():Object
                                       {
                                          return {
                                             "enabled":false,
                                             "styleName":"longButtonBLue",
                                             "tabEnabled":false
                                          };
                                       }
                                    }),new UIComponentDescriptor({
                                       "type":SoundEffectButton,
                                       "id":"buttonCancel",
                                       "events":{"click":"__buttonCancel_click"},
                                       "propertiesFactory":function():Object
                                       {
                                          return {
                                             "enabled":true,
                                             "styleName":"longButtonBLue",
                                             "tabEnabled":false
                                          };
                                       }
                                    })]
                                 };
                              }
                           })]
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Button,
                     "id":"windowClose_btn",
                     "events":{"click":"__windowClose_btn_click"},
                     "stylesFactory":function():void
                     {
                        this.top = "10";
                        this.right = "10";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"inviteFacebookFriendsCloseBtn",
                           "buttonMode":true,
                           "useHandCursor":true,
                           "tabEnabled":false
                        };
                     }
                  })]
               };
            }
         });
         this.onClosed = new Signal();
         this.onSendReport = new Signal();
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
            this.borderStyle = "solid";
            this.borderThickness = 2;
            this.borderColor = 1118481;
            this.cornerRadius = 4;
         };
         this.height = 400;
         this.width = 500;
         this.styleName = "chatBackground";
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("creationComplete",this.___ReportPlayerView_GradientCanvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ReportPlayerView._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerCallout() : Label
      {
         return this._944061186summonerCallout;
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonCancel() : SoundEffectButton
      {
         return this._473928780buttonCancel;
      }
      
      public function set offences(param1:ComboBox) : void
      {
         var _loc2_:Object = this._768661767offences;
         if(_loc2_ !== param1)
         {
            this._768661767offences = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"offences",_loc2_,param1));
         }
      }
      
      public function set summonerCallout(param1:Label) : void
      {
         var _loc2_:Object = this._944061186summonerCallout;
         if(_loc2_ !== param1)
         {
            this._944061186summonerCallout = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerCallout",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get windowClose_btn() : Button
      {
         return this._1588167045windowClose_btn;
      }
      
      private function onMailComplete(param1:Boolean) : void
      {
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ReportPlayerView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ReportPlayerView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_Support_ReportPlayerViewWatcherSetupUtil");
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
      
      public function getOnSendReport() : ISignal
      {
         return this.onSendReport;
      }
      
      public function set windowClose_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1588167045windowClose_btn;
         if(_loc2_ !== param1)
         {
            this._1588167045windowClose_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"windowClose_btn",_loc2_,param1));
         }
      }
      
      private function _ReportPlayerView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = resourceManager.getString("resources","reportPlayerDialogHeader");
         _loc1_ = resourceManager.getString("resources","reportPlayer_playerToReportFieldLabel");
         _loc1_ = this.player.summonerName;
         _loc1_ = resourceManager.getString("resources","reportPlayer_offenceSelectionLabel");
         _loc1_ = resourceManager.getString("resources","reportPlayer_additionalComments");
         _loc1_ = resourceManager.getString("resources","reportPlayer_submitButtonLabel");
         _loc1_ = resourceManager.getString("resources","common_button_cancel");
         _loc1_ = resourceManager.getString("resources","preferences_cancelButtonLabel");
      }
      
      public function getOnClosed() : ISignal
      {
         return this.onClosed;
      }
      
      [Bindable(event="propertyChange")]
      public function get offences() : ComboBox
      {
         return this._768661767offences;
      }
      
      public function set buttonCancel(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._473928780buttonCancel;
         if(_loc2_ !== param1)
         {
            this._473928780buttonCancel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonCancel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get commentInput() : TextArea
      {
         return this._775134379commentInput;
      }
      
      public function __buttonCancel_click(param1:MouseEvent) : void
      {
         this.cancelReport();
      }
      
      private function onCreationComplete() : void
      {
         var _loc1_:Array = [{
            "label":resourceManager.getString("resources","reportPlayerOffense_offensiveLanguage"),
            "data":ReportReasonConstants.OFFENSIVE_LANGUAGE
         },{
            "label":resourceManager.getString("resources","reportPlayerOffense_verbalAbuse"),
            "data":ReportReasonConstants.VERBAL_ABUSE
         },{
            "label":resourceManager.getString("resources","reportPlayerOffense_intentionalFeeding"),
            "data":ReportReasonConstants.INTENTIONAL_FEEDING
         },{
            "label":resourceManager.getString("resources","reportPlayerOffense_assistingEnemy"),
            "data":ReportReasonConstants.ASSISTING_ENEMY
         },{
            "label":resourceManager.getString("resources","reportPlayerOffense_unskilledPlayer"),
            "data":ReportReasonConstants.UNSKILLED_PLAYER,
            "toolTip":resourceManager.getString("resources","reportPlayerOffense_unskilledPlayer_toolTip")
         },{
            "label":resourceManager.getString("resources","reportPlayerOffense_noCommunication"),
            "data":ReportReasonConstants.NO_COMMUNICATION_WITH_TEAM
         },{
            "label":resourceManager.getString("resources","reportPlayerOffense_leavingAFK"),
            "data":ReportReasonConstants.LEAVING_AFK
         },{
            "label":resourceManager.getString("resources","reportPlayerOffense_badAttitude"),
            "data":ReportReasonConstants.NEGATIVE_ATTITUDE
         },{
            "label":resourceManager.getString("resources","reportPlayerOffense_inappropriateName"),
            "data":ReportReasonConstants.INAPPROPRIATE_NAME
         },{
            "label":resourceManager.getString("resources","reportPlayerOffense_spamming"),
            "data":ReportReasonConstants.SPAMMING
         }];
         _loc1_.sortOn(["label"]);
         _loc1_.unshift({
            "label":resourceManager.getString("resources","reportPlayerOffense_prompt"),
            "data":ReportReasonConstants.EMPTY_REASON
         });
         this.offences.dataProvider = _loc1_;
      }
      
      private function generateUrl(param1:String, param2:String, ... rest) : Object
      {
         var _loc8_:URLVariables = null;
         var _loc4_:Object = null;
         var _loc5_:String = ResourceManager.getInstance().getString("resources","reportPlayerURL");
         var _loc6_:Array = new Array();
         if(rest.length > 0)
         {
            this.parseArguments(_loc6_,rest);
         }
         _loc6_.sort();
         var _loc7_:String = _loc6_.join("&");
         if(param2 == URLRequestMethod.GET)
         {
            _loc4_ = _loc5_ + param1 + "?" + _loc7_;
         }
         else if(param2 == URLRequestMethod.POST)
         {
            _loc4_ = new Object();
            _loc4_["url"] = _loc5_ + param1;
            _loc8_ = new URLVariables(_loc7_);
            _loc4_["data"] = _loc8_;
         }
         return _loc4_;
      }
      
      public function ___ReportPlayerView_GradientCanvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function _ReportPlayerView_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ReportPlayerViewItemRenderer;
         return _loc1_;
      }
      
      public function set player(param1:PlayerParticipantStatsSummary) : void
      {
         var _loc2_:Object = this._985752863player;
         if(_loc2_ !== param1)
         {
            this._985752863player = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player",_loc2_,param1));
         }
      }
      
      private function _ReportPlayerView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","reportPlayerDialogHeader");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ReportPlayerView_Label1.text = param1;
         },"_ReportPlayerView_Label1.text");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","reportPlayer_playerToReportFieldLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ReportPlayerView_Label2.text = param1;
         },"_ReportPlayerView_Label2.text");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = player.summonerName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            summonerCallout.text = param1;
         },"summonerCallout.text");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","reportPlayer_offenceSelectionLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ReportPlayerView_Label4.text = param1;
         },"_ReportPlayerView_Label4.text");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","reportPlayer_additionalComments");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ReportPlayerView_Label5.text = param1;
         },"_ReportPlayerView_Label5.text");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","reportPlayer_submitButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            buttonSubmit.label = param1;
         },"buttonSubmit.label");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","common_button_cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            buttonCancel.label = param1;
         },"buttonCancel.label");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_cancelButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            windowClose_btn.toolTip = param1;
         },"windowClose_btn.toolTip");
         result[7] = binding;
         return result;
      }
      
      public function __buttonSubmit_click(param1:MouseEvent) : void
      {
         this.sendReport();
      }
      
      public function set buttonSubmit(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._950117866buttonSubmit;
         if(_loc2_ !== param1)
         {
            this._950117866buttonSubmit = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonSubmit",_loc2_,param1));
         }
      }
      
      private function cancelReport() : void
      {
         this.onClosed.dispatch(this.onClosed);
      }
      
      private function sendReport() : void
      {
         var _loc1_:PlayerComplaint = new PlayerComplaint();
         _loc1_.reportSource = this.gameID == Number.MIN_VALUE ? "CHAT" : "GAME";
         _loc1_.reportingSummonerId = Session.instance.summoner.sumId;
         var _loc2_:String = this.player.userId.toString();
         _loc1_.reportedSummonerId = parseFloat(_loc2_);
         _loc1_.offense = this.offences.selectedItem.data;
         _loc1_.comment = this.commentInput.text;
         _loc1_.gameId = this.gameID;
         this.player.reportEnabled = false;
         this.player.kudosEnabled = false;
         this.onSendReport.dispatch(this.onSendReport,_loc1_,this.summonerCallout.text);
      }
      
      public function __offences_change(param1:ListEvent) : void
      {
         this.offencesChanged(param1);
      }
      
      public function set commentInput(param1:TextArea) : void
      {
         var _loc2_:Object = this._775134379commentInput;
         if(_loc2_ !== param1)
         {
            this._775134379commentInput = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"commentInput",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get player() : PlayerParticipantStatsSummary
      {
         return this._985752863player;
      }
      
      private function onError(param1:IOErrorEvent) : void
      {
      }
      
      private function parseArguments(param1:Array, param2:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         for(_loc3_ in param2)
         {
            if(param2[_loc3_] is String)
            {
               param1.push(param2[_loc3_]);
            }
            else if(param2[_loc3_] is Array)
            {
               this.parseArguments(param1,param2[_loc3_]);
            }
            else
            {
               for(_loc4_ in param2[_loc3_])
               {
                  param1.push(_loc4_ + "=" + param2[_loc3_][_loc4_]);
               }
            }
         }
      }
      
      private function onMailSuccess() : void
      {
      }
      
      public function __windowClose_btn_click(param1:MouseEvent) : void
      {
         this.cancelReport();
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonSubmit() : SoundEffectButton
      {
         return this._950117866buttonSubmit;
      }
      
      private function onMailError(param1:MailError) : void
      {
      }
      
      public function cancel() : void
      {
         this.cancelReport();
      }
      
      private function offencesChanged(param1:ListEvent) : void
      {
         this.buttonSubmit.enabled = param1.currentTarget.selectedIndex != ReportReasonConstants.EMPTY_REASON;
      }
   }
}

