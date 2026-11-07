package com.riotgames.pvpnet.invite.legacy.view
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.components.controls.ToggleButtonBar;
   import com.riotgames.platform.gameclient.components.WingedHeader;
   import com.riotgames.pvpnet.invite.configurations.GuestSlotsConfig;
   import com.riotgames.pvpnet.invite.legacy.controller.InviteBayController;
   import com.riotgames.pvpnet.invite.legacy.enum.InviteSectionTypeEnums;
   import com.riotgames.pvpnet.invite.legacy.event.InviteBayEvent;
   import com.riotgames.pvpnet.invite.legacy.factory.InvitePlayerCardFactory;
   import com.riotgames.pvpnet.invite.legacy.renderer.InviteBayPlayersViewRenderer;
   import com.riotgames.pvpnet.invite.rules.IInviteBayRules;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
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
   import flexlib.controls.PromptingTextInput;
   import mx.binding.*;
   import mx.containers.Canvas;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.ComboBox;
   import mx.controls.List;
   import mx.controls.Text;
   import mx.controls.TextInput;
   import mx.core.ClassFactory;
   import mx.core.IUIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.DefaultListEffect;
   import mx.effects.Fade;
   import mx.effects.Parallel;
   import mx.events.CollectionEvent;
   import mx.events.DragEvent;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.ItemClickEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.DragManager;
   import mx.styles.*;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class InvitePlayersView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _282063162availPlayers_lbl:WingedHeader;
      
      private var _chooseAvailablePlayersClickedSignal:Signal = new Signal();
      
      private var _1808615324activateEffect:Parallel;
      
      private var _removePlayerInviteClickedSignal:Signal = new Signal();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      public var _InvitePlayersView_Text1:Text;
      
      private var _284062329popUpHeader:WingedHeader;
      
      private var _guestSlotsEnabledConfig:ConfigurationModel;
      
      private var _1058326740invitePlayersClose_btn:Button;
      
      private var _2049260831listChangeEffect:DefaultListEffect;
      
      private var _1180619197isBusy:Boolean = false;
      
      private var _1281862409invitePlayers_lst:List;
      
      private var _filterTextChangedSignal:Signal = new Signal();
      
      private var _1281862944invitePlayers_lbl:WingedHeader;
      
      private var _2137684561_inviteRules:IInviteBayRules;
      
      private var _1984395688playerLists_vs:Canvas;
      
      private var _addPlayerInviteClickedSignal:Signal = new Signal();
      
      private var _1154107748_numGuestSlots:int = 0;
      
      private var _634955967_numGuestSlotsUsed:int = 0;
      
      private var _isRankedSoloQueue:Boolean = false;
      
      private var _1895195799chatListChangeEffect:DefaultListEffect;
      
      private var _492822019chooseAvailPlayersLst_btnbar:ToggleButtonBar;
      
      private var _2147164506selectionIndex:int = -1;
      
      private var _invitePlayerClickedSignal:Signal = new Signal();
      
      private var _705980169invitePlayerByName_btn:Button;
      
      private var _1281871994invitePlayers_btn:Button;
      
      private var _1362699224invitePlayerByName_ti:TextInput;
      
      private var _closeClickedSignal:Signal = new Signal();
      
      private var _1522088373availablePlayers_cb:ComboBox;
      
      private var _1133197415teamGuestSlotsEnabled:Boolean = false;
      
      private var glowFilter:GlowFilter = new GlowFilter(16777215,0.5,55,55);
      
      private var _175193153inviteColumn:ConstraintColumn;
      
      private var _881372004filter_ti:PromptingTextInput;
      
      private var _616451877deactivateEffect:Parallel;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _52801665availableColumn:ConstraintColumn;
      
      private var _397955935guestSlots_cb:CheckBox;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      private var _1499317958inviteeList:List;
      
      private var _inviteAllClickedSignal:Signal = new Signal();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":PromptingTextInput,
               "id":"filter_ti",
               "events":{"change":"__filter_ti_change"},
               "propertiesFactory":function():Object
               {
                  return {
                     "width":300,
                     "maxChars":20,
                     "styleName":"invitePanel"
                  };
               }
            }),new UIComponentDescriptor({
               "type":ComboBox,
               "id":"availablePlayers_cb",
               "events":{"valueCommit":"__availablePlayers_cb_valueCommit"},
               "propertiesFactory":function():Object
               {
                  return {"width":300};
               }
            }),new UIComponentDescriptor({
               "type":CheckBox,
               "id":"guestSlots_cb",
               "events":{"click":"__guestSlots_cb_click"}
            }),new UIComponentDescriptor({
               "type":WingedHeader,
               "id":"popUpHeader",
               "stylesFactory":function():void
               {
                  this.top = "30";
                  this.left = "10";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"summonerInfoHeader",
                     "showWing":false,
                     "firstLetterFontSize":32,
                     "remainingLettersFontSize":32
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"_InvitePlayersView_Text1",
               "stylesFactory":function():void
               {
                  this.fontSize = 12;
                  this.top = "15";
                  this.horizontalCenter = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {"styleName":"yellowHeader"};
               }
            }),new UIComponentDescriptor({
               "type":WingedHeader,
               "id":"availPlayers_lbl",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "availableColumn:0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"summonerInfoHeader",
                     "showWing":true
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"playerLists_vs",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "availableColumn:0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":List,
                        "id":"inviteeList",
                        "events":{
                           "initialize":"__inviteeList_initialize",
                           "dragDrop":"__inviteeList_dragDrop",
                           "dragEnter":"__inviteeList_dragEnter",
                           "dragOver":"__inviteeList_dragOver"
                        },
                        "stylesFactory":function():void
                        {
                           this.backgroundColor = 0;
                           this.backgroundAlpha = 0.5;
                           this.borderStyle = "solid";
                           this.selectionColor = 0;
                           this.borderColor = 5592405;
                           this.useRollOver = false;
                           this.paddingRight = 15;
                           this.paddingLeft = 5;
                           this.verticalScrollBarStyleName = "wide";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "x":0,
                              "y":0,
                              "percentWidth":100,
                              "percentHeight":100,
                              "rowHeight":65,
                              "allowMultipleSelection":true,
                              "dragEnabled":true,
                              "dropEnabled":true,
                              "variableRowHeight":false
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":TextInput,
               "id":"invitePlayerByName_ti",
               "events":{"enter":"__invitePlayerByName_ti_enter"},
               "propertiesFactory":function():Object
               {
                  return {
                     "width":300,
                     "maxChars":20,
                     "styleName":"invitePanel"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Button,
               "id":"invitePlayerByName_btn",
               "events":{"click":"__invitePlayerByName_btn_click"},
               "propertiesFactory":function():Object
               {
                  return {
                     "buttonMode":true,
                     "styleName":"blue"
                  };
               }
            }),new UIComponentDescriptor({
               "type":WingedHeader,
               "id":"invitePlayers_lbl",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "inviteColumn:0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"summonerInfoHeader",
                     "showWing":true
                  };
               }
            }),new UIComponentDescriptor({
               "type":List,
               "id":"invitePlayers_lst",
               "events":{
                  "initialize":"__invitePlayers_lst_initialize",
                  "dragDrop":"__invitePlayers_lst_dragDrop",
                  "dragEnter":"__invitePlayers_lst_dragEnter",
                  "dragOver":"__invitePlayers_lst_dragOver"
               },
               "stylesFactory":function():void
               {
                  this.backgroundAlpha = 0.5;
                  this.useRollOver = false;
                  this.borderStyle = "solid";
                  this.borderColor = 5592405;
                  this.backgroundColor = 0;
                  this.selectionColor = 0;
                  this.horizontalCenter = "inviteColumn:0";
                  this.paddingRight = 15;
                  this.paddingLeft = 5;
                  this.verticalScrollBarStyleName = "wide";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"optionsTitle",
                     "rowHeight":65,
                     "dragEnabled":true,
                     "dropEnabled":true,
                     "variableRowHeight":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":ToggleButtonBar,
               "id":"chooseAvailPlayersLst_btnbar",
               "events":{"itemClick":"__chooseAvailPlayersLst_btnbar_itemClick"},
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "availableColumn:0";
                  this.bottom = "5";
               },
               "propertiesFactory":function():Object
               {
                  return {"styleName":"blueToggleButtonBar"};
               }
            }),new UIComponentDescriptor({
               "type":Button,
               "id":"invitePlayersClose_btn",
               "events":{"click":"__invitePlayersClose_btn_click"},
               "stylesFactory":function():void
               {
                  this.top = "5";
                  this.right = "5";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"windowClose",
                     "buttonMode":true
                  };
               }
            }),new UIComponentDescriptor({
               "type":Button,
               "id":"invitePlayers_btn",
               "events":{"click":"__invitePlayers_btn_click"},
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "inviteColumn:0";
                  this.bottom = "5";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "buttonMode":true,
                     "styleName":"blue"
                  };
               }
            })]};
         }
      });
      
      private var _allowGuestsChangedSignal:Signal = new Signal();
      
      public function InvitePlayersView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.styleName = "popupTablet";
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.constraintColumns = [this._InvitePlayersView_ConstraintColumn1_i(),this._InvitePlayersView_ConstraintColumn2_i()];
         this._InvitePlayersView_Parallel1_i();
         this._InvitePlayersView_DefaultListEffect2_i();
         this._InvitePlayersView_Parallel2_i();
         this._InvitePlayersView_DefaultListEffect1_i();
         this.addEventListener("creationComplete",this.___InvitePlayersView_Canvas1_creationComplete);
         this.addEventListener("addedToStage",this.___InvitePlayersView_Canvas1_addedToStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         InvitePlayersView._watcherSetupUtil = param1;
      }
      
      public function get chooseAvailPlayersLst_btnbar() : ToggleButtonBar
      {
         return this._492822019chooseAvailPlayersLst_btnbar;
      }
      
      private function handleRemovePlayerInviteEvent(param1:InviteBayEvent) : void
      {
         this.updateGuestSlotCount();
         this._removePlayerInviteClickedSignal.dispatch([param1.rosterItem]);
      }
      
      public function set chooseAvailPlayersLst_btnbar(param1:ToggleButtonBar) : void
      {
         var _loc2_:Object = this._492822019chooseAvailPlayersLst_btnbar;
         if(_loc2_ !== param1)
         {
            this._492822019chooseAvailPlayersLst_btnbar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chooseAvailPlayersLst_btnbar",_loc2_,param1));
         }
      }
      
      private function onGuestSlotsClicked(param1:MouseEvent) : void
      {
         this._allowGuestsChangedSignal.dispatch(this.guestSlots_cb.selected);
      }
      
      private function setAvailableInviteListRenderer() : void
      {
         this.inviteeList.itemRenderer = InvitePlayerCardFactory.createRendererFactory({
            "isAddBuddy":true,
            "inviteRules":this._inviteRules
         });
      }
      
      public function set invitePlayerByName_btn(param1:Button) : void
      {
         var _loc2_:Object = this._705980169invitePlayerByName_btn;
         if(_loc2_ !== param1)
         {
            this._705980169invitePlayerByName_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invitePlayerByName_btn",_loc2_,param1));
         }
      }
      
      public function getAllowGuestsChangedSignal() : ISignal
      {
         return this._allowGuestsChangedSignal;
      }
      
      public function __invitePlayerByName_ti_enter(param1:FlexEvent) : void
      {
         this.onInvitePlayerSubmit();
      }
      
      public function getChooseAvailalablePlayersClickedSignal() : ISignal
      {
         return this._chooseAvailablePlayersClickedSignal;
      }
      
      public function get invitePlayerByName_ti() : TextInput
      {
         return this._1362699224invitePlayerByName_ti;
      }
      
      public function getRemovePlayerInviteClickedSignal() : ISignal
      {
         return this._removePlayerInviteClickedSignal;
      }
      
      private function onInvitePlayersListInitialize() : void
      {
         if(this.teamGuestSlotsEnabled)
         {
            InvitePlayerCardFactory.instance.assetsLoaded.add(this.setInvitedPlayersListRenderer);
            if(InvitePlayerCardFactory.instance.haveAssetsLoaded)
            {
               this.setInvitedPlayersListRenderer();
            }
         }
         else
         {
            this.invitePlayers_lst.itemRenderer = new ClassFactory(InviteBayPlayersViewRenderer);
            (this.invitePlayers_lst.itemRenderer as ClassFactory).properties = {
               "isAddBuddy":false,
               "isRankedSoloQueue":this._isRankedSoloQueue
            };
         }
      }
      
      private function _InvitePlayersView_Parallel1_i() : Parallel
      {
         var _loc1_:Parallel = new Parallel();
         this.activateEffect = _loc1_;
         _loc1_.children = [this._InvitePlayersView_Fade1_c()];
         BindingManager.executeBindings(this,"activateEffect",this.activateEffect);
         return _loc1_;
      }
      
      public function set listChangeEffect(param1:DefaultListEffect) : void
      {
         var _loc2_:Object = this._2049260831listChangeEffect;
         if(_loc2_ !== param1)
         {
            this._2049260831listChangeEffect = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"listChangeEffect",_loc2_,param1));
         }
      }
      
      private function onInvitePlayerSubmit() : void
      {
         var _loc1_:String = this.invitePlayerByName_ti.text;
         this._invitePlayerClickedSignal.dispatch(_loc1_);
      }
      
      public function get isBusy() : Boolean
      {
         return this._1180619197isBusy;
      }
      
      public function __invitePlayers_lst_dragOver(param1:DragEvent) : void
      {
         this.onDragEvent(param1);
      }
      
      public function set deactivateEffect(param1:Parallel) : void
      {
         var _loc2_:Object = this._616451877deactivateEffect;
         if(_loc2_ !== param1)
         {
            this._616451877deactivateEffect = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deactivateEffect",_loc2_,param1));
         }
      }
      
      public function set invitePlayerByName_ti(param1:TextInput) : void
      {
         var _loc2_:Object = this._1362699224invitePlayerByName_ti;
         if(_loc2_ !== param1)
         {
            this._1362699224invitePlayerByName_ti = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invitePlayerByName_ti",_loc2_,param1));
         }
      }
      
      public function set invitePlayersClose_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1058326740invitePlayersClose_btn;
         if(_loc2_ !== param1)
         {
            this._1058326740invitePlayersClose_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invitePlayersClose_btn",_loc2_,param1));
         }
      }
      
      private function _InvitePlayersView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            activateEffect.target = param1;
         },"activateEffect.target");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            deactivateEffect.target = param1;
         },"deactivateEffect.target");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = playerLists_vs.x;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            filter_ti.setStyle("left",param1);
         },"filter_ti.left");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.height * 0.18;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            filter_ti.setStyle("top",param1);
         },"filter_ti.top");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_playerFilterPrompt");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            filter_ti.prompt = param1;
         },"filter_ti.prompt");
         result[4] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _inviteRules.sectionType != InviteSectionTypeEnums.SECTION_TYPE_COMBOBOX;
         },function(param1:Boolean):void
         {
            filter_ti.visible = param1;
         },"filter_ti.visible");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = playerLists_vs.x;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            availablePlayers_cb.setStyle("left",param1);
         },"availablePlayers_cb.left");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.height * 0.18;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            availablePlayers_cb.setStyle("top",param1);
         },"availablePlayers_cb.top");
         result[7] = binding;
         binding = new Binding(this,function():int
         {
            return this.selectionIndex;
         },function(param1:int):void
         {
            availablePlayers_cb.selectedIndex = param1;
         },"availablePlayers_cb.selectedIndex");
         result[8] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _inviteRules.sectionType == InviteSectionTypeEnums.SECTION_TYPE_COMBOBOX;
         },function(param1:Boolean):void
         {
            availablePlayers_cb.visible = param1;
         },"availablePlayers_cb.visible");
         result[9] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !_inviteRules.sectionLocked;
         },function(param1:Boolean):void
         {
            availablePlayers_cb.enabled = param1;
         },"availablePlayers_cb.enabled");
         result[10] = binding;
         binding = new Binding(this,function():Object
         {
            return _inviteRules.sectionNames;
         },function(param1:Object):void
         {
            availablePlayers_cb.dataProvider = param1;
         },"availablePlayers_cb.dataProvider");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = _inviteRules.sectionLocked ? _inviteRules.sectionLockedTooltip : "";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            availablePlayers_cb.toolTip = param1;
         },"availablePlayers_cb.toolTip");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = playerLists_vs.x + 310;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            guestSlots_cb.setStyle("left",param1);
         },"guestSlots_cb.left");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.height * 0.18;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            guestSlots_cb.setStyle("top",param1);
         },"guestSlots_cb.top");
         result[14] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _inviteRules.sectionType == InviteSectionTypeEnums.SECTION_TYPE_COMBOBOX && teamGuestSlotsEnabled && Boolean(ClientConfig.instance.leagueServiceEnabled);
         },function(param1:Boolean):void
         {
            guestSlots_cb.visible = param1;
         },"guestSlots_cb.visible");
         result[15] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this._numGuestSlots > 0;
         },function(param1:Boolean):void
         {
            guestSlots_cb.enabled = param1;
         },"guestSlots_cb.enabled");
         result[16] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_guestSlots",[this._numGuestSlotsUsed,this._numGuestSlots]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            guestSlots_cb.label = param1;
         },"guestSlots_cb.label");
         result[17] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_title_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            popUpHeader.headerText = param1;
         },"popUpHeader.headerText");
         result[18] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = WingedHeader.ORANGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            popUpHeader.currentState = param1;
         },"popUpHeader.currentState");
         result[19] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_subtitle_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InvitePlayersView_Text1.text = param1;
         },"_InvitePlayersView_Text1.text");
         result[20] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = WingedHeader.YELLOW;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            availPlayers_lbl.currentState = param1;
         },"availPlayers_lbl.currentState");
         result[21] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.height - filter_ti.y;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            availPlayers_lbl.setStyle("bottom",param1);
         },"availPlayers_lbl.bottom");
         result[22] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_availablePlayersHeader_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            availPlayers_lbl.headerText = param1;
         },"availPlayers_lbl.headerText");
         result[23] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = filter_ti.y + filter_ti.height + 8;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playerLists_vs.setStyle("top",param1);
         },"playerLists_vs.top");
         result[24] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.height - chooseAvailPlayersLst_btnbar.y;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playerLists_vs.setStyle("bottom",param1);
         },"playerLists_vs.bottom");
         result[25] = binding;
         binding = new Binding(this,function():Number
         {
            return availableColumn.width * 0.85;
         },function(param1:Number):void
         {
            playerLists_vs.width = param1;
         },"playerLists_vs.width");
         result[26] = binding;
         binding = new Binding(this,function():Object
         {
            return _inviteRules.availableInvitees;
         },function(param1:Object):void
         {
            inviteeList.dataProvider = param1;
         },"inviteeList.dataProvider");
         result[27] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = invitePlayers_lst.x;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayerByName_ti.setStyle("left",param1);
         },"invitePlayerByName_ti.left");
         result[28] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.height * 0.18;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayerByName_ti.setStyle("top",param1);
         },"invitePlayerByName_ti.top");
         result[29] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _inviteRules.allowInviteByName;
         },function(param1:Boolean):void
         {
            invitePlayerByName_ti.visible = param1;
         },"invitePlayerByName_ti.visible");
         result[30] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = invitePlayerByName_ti.x + 305;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayerByName_btn.setStyle("left",param1);
         },"invitePlayerByName_btn.left");
         result[31] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.height * 0.18;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayerByName_btn.setStyle("top",param1);
         },"invitePlayerByName_btn.top");
         result[32] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_invitePlayerByNameButton_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayerByName_btn.label = param1;
         },"invitePlayerByName_btn.label");
         result[33] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_invitePlayerByNameButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayerByName_btn.toolTip = param1;
         },"invitePlayerByName_btn.toolTip");
         result[34] = binding;
         binding = new Binding(this,function():Boolean
         {
            return invitePlayerByName_ti.text.length > 0 && !isBusy;
         },function(param1:Boolean):void
         {
            invitePlayerByName_btn.enabled = param1;
         },"invitePlayerByName_btn.enabled");
         result[35] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _inviteRules.allowInviteByName;
         },function(param1:Boolean):void
         {
            invitePlayerByName_btn.visible = param1;
         },"invitePlayerByName_btn.visible");
         result[36] = binding;
         binding = new Binding(this,function():Number
         {
            return availPlayers_lbl.y;
         },function(param1:Number):void
         {
            invitePlayers_lbl.y = param1;
         },"invitePlayers_lbl.y");
         result[37] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = WingedHeader.ORANGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayers_lbl.currentState = param1;
         },"invitePlayers_lbl.currentState");
         result[38] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_inviteListHeader_label",["(" + _inviteRules.availableInviteBay.length + "/" + InviteBayController.MAX_NUM_INVITE_BAY_PLAYERS + ")"]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayers_lbl.headerText = param1;
         },"invitePlayers_lbl.headerText");
         result[39] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = filter_ti.y + filter_ti.height + 8;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayers_lst.setStyle("top",param1);
         },"invitePlayers_lst.top");
         result[40] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.height - chooseAvailPlayersLst_btnbar.y;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayers_lst.setStyle("bottom",param1);
         },"invitePlayers_lst.bottom");
         result[41] = binding;
         binding = new Binding(this,function():Number
         {
            return inviteColumn.width * 0.85;
         },function(param1:Number):void
         {
            invitePlayers_lst.width = param1;
         },"invitePlayers_lst.width");
         result[42] = binding;
         binding = new Binding(this,function():Object
         {
            return _inviteRules.availableInviteBay;
         },function(param1:Object):void
         {
            invitePlayers_lst.dataProvider = param1;
         },"invitePlayers_lst.dataProvider");
         result[43] = binding;
         binding = new Binding(this,function():int
         {
            return this.selectionIndex;
         },function(param1:int):void
         {
            chooseAvailPlayersLst_btnbar.selectedIndex = param1;
         },"chooseAvailPlayersLst_btnbar.selectedIndex");
         result[44] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _inviteRules.sectionType == InviteSectionTypeEnums.SECTION_TYPE_TABS;
         },function(param1:Boolean):void
         {
            chooseAvailPlayersLst_btnbar.visible = param1;
         },"chooseAvailPlayersLst_btnbar.visible");
         result[45] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !_inviteRules.sectionLocked;
         },function(param1:Boolean):void
         {
            chooseAvailPlayersLst_btnbar.enabled = param1;
         },"chooseAvailPlayersLst_btnbar.enabled");
         result[46] = binding;
         binding = new Binding(this,function():Object
         {
            return _inviteRules.sectionNames;
         },function(param1:Object):void
         {
            chooseAvailPlayersLst_btnbar.dataProvider = param1;
         },"chooseAvailPlayersLst_btnbar.dataProvider");
         result[47] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_closeWindowButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayersClose_btn.toolTip = param1;
         },"invitePlayersClose_btn.toolTip");
         result[48] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_invitePlayersButton_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayers_btn.label = param1;
         },"invitePlayers_btn.label");
         result[49] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_invitePlayersButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            invitePlayers_btn.toolTip = param1;
         },"invitePlayers_btn.toolTip");
         result[50] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _inviteRules.availableInviteBay.length > 0 && !this.isBusy;
         },function(param1:Boolean):void
         {
            invitePlayers_btn.enabled = param1;
         },"invitePlayers_btn.enabled");
         result[51] = binding;
         return result;
      }
      
      private function onDeactiveEffectEnd() : void
      {
         if(Boolean(this._inviteRules) && Boolean(this._inviteRules.sectionNames))
         {
            this._inviteRules.sectionNames.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSectionNamesCollectionChanged);
            this._inviteRules.getSectionChangedSignal().remove(this.updateSelectionIndex);
            this._inviteRules.getNumGuestSlotsChangedSignal().remove(this.updateGuestSlotCount);
         }
         this._closeClickedSignal.dispatch();
      }
      
      private function onDragDropRemove(param1:DragEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
         if(param1.dragSource.hasFormat("items"))
         {
            this.updateGuestSlotCount();
            this._removePlayerInviteClickedSignal.dispatch(param1.dragSource.dataForFormat("items") as Array);
         }
      }
      
      private function get teamGuestSlotsEnabled() : Boolean
      {
         return this._1133197415teamGuestSlotsEnabled;
      }
      
      public function get activateEffect() : Parallel
      {
         return this._1808615324activateEffect;
      }
      
      public function set availPlayers_lbl(param1:WingedHeader) : void
      {
         var _loc2_:Object = this._282063162availPlayers_lbl;
         if(_loc2_ !== param1)
         {
            this._282063162availPlayers_lbl = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availPlayers_lbl",_loc2_,param1));
         }
      }
      
      private function playDeactivateEffect() : void
      {
         this.deactivateEffect.end();
         this.deactivateEffect.play();
      }
      
      public function __invitePlayers_lst_dragDrop(param1:DragEvent) : void
      {
         this.onDragDropAdd(param1);
      }
      
      public function set inviteeList(param1:List) : void
      {
         var _loc2_:Object = this._1499317958inviteeList;
         if(_loc2_ !== param1)
         {
            this._1499317958inviteeList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteeList",_loc2_,param1));
         }
      }
      
      public function get popUpHeader() : WingedHeader
      {
         return this._284062329popUpHeader;
      }
      
      private function set _numGuestSlotsUsed(param1:int) : void
      {
         var _loc2_:Object = this._634955967_numGuestSlotsUsed;
         if(_loc2_ !== param1)
         {
            this._634955967_numGuestSlotsUsed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_numGuestSlotsUsed",_loc2_,param1));
         }
      }
      
      public function set isBusy(param1:Boolean) : void
      {
         var _loc2_:Object = this._1180619197isBusy;
         if(_loc2_ !== param1)
         {
            this._1180619197isBusy = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBusy",_loc2_,param1));
         }
      }
      
      public function __guestSlots_cb_click(param1:MouseEvent) : void
      {
         this.onGuestSlotsClicked(param1);
      }
      
      public function getCloseClickedSignal() : ISignal
      {
         return this._closeClickedSignal;
      }
      
      public function __filter_ti_change(param1:Event) : void
      {
         this.doTextFilter(param1);
      }
      
      public function __invitePlayersClose_btn_click(param1:MouseEvent) : void
      {
         this.playDeactivateEffect();
      }
      
      public function get chatListChangeEffect() : DefaultListEffect
      {
         return this._1895195799chatListChangeEffect;
      }
      
      public function get filter_ti() : PromptingTextInput
      {
         return this._881372004filter_ti;
      }
      
      public function __availablePlayers_cb_valueCommit(param1:FlexEvent) : void
      {
         this.chooseAvailPlayersComboSelected(param1);
      }
      
      public function get guestSlots_cb() : CheckBox
      {
         return this._397955935guestSlots_cb;
      }
      
      private function onDragEvent(param1:DragEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
         if(Boolean(param1.dragSource.hasFormat("items")) && this.isDragDropEnabledForItems(param1))
         {
            DragManager.acceptDragDrop(param1.target as IUIComponent);
         }
      }
      
      private function get selectionIndex() : int
      {
         return this._2147164506selectionIndex;
      }
      
      private function chooseAvailPlayersLstClicked(param1:ItemClickEvent) : void
      {
         this._chooseAvailablePlayersClickedSignal.dispatch(param1.index);
      }
      
      public function __invitePlayerByName_btn_click(param1:MouseEvent) : void
      {
         this.onInvitePlayerSubmit();
      }
      
      public function set isRankedSoloQueue(param1:Boolean) : void
      {
         this._isRankedSoloQueue = param1;
      }
      
      private function set _numGuestSlots(param1:int) : void
      {
         var _loc2_:Object = this._1154107748_numGuestSlots;
         if(_loc2_ !== param1)
         {
            this._1154107748_numGuestSlots = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_numGuestSlots",_loc2_,param1));
         }
      }
      
      public function set activateEffect(param1:Parallel) : void
      {
         var _loc2_:Object = this._1808615324activateEffect;
         if(_loc2_ !== param1)
         {
            this._1808615324activateEffect = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"activateEffect",_loc2_,param1));
         }
      }
      
      public function __deactivateEffect_effectEnd(param1:EffectEvent) : void
      {
         this.onDeactiveEffectEnd();
      }
      
      private function set teamGuestSlotsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1133197415teamGuestSlotsEnabled;
         if(_loc2_ !== param1)
         {
            this._1133197415teamGuestSlotsEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamGuestSlotsEnabled",_loc2_,param1));
         }
      }
      
      private function _InvitePlayersView_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.inviteColumn = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"inviteColumn");
         return _loc1_;
      }
      
      public function __invitePlayers_lst_dragEnter(param1:DragEvent) : void
      {
         this.onDragEvent(param1);
      }
      
      public function __chooseAvailPlayersLst_btnbar_itemClick(param1:ItemClickEvent) : void
      {
         this.chooseAvailPlayersLstClicked(param1);
      }
      
      public function get invitePlayers_lbl() : WingedHeader
      {
         return this._1281862944invitePlayers_lbl;
      }
      
      private function chooseAvailPlayersComboSelected(param1:FlexEvent) : void
      {
         this._chooseAvailablePlayersClickedSignal.dispatch(this.availablePlayers_cb.selectedIndex);
      }
      
      public function set popUpHeader(param1:WingedHeader) : void
      {
         var _loc2_:Object = this._284062329popUpHeader;
         if(_loc2_ !== param1)
         {
            this._284062329popUpHeader = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"popUpHeader",_loc2_,param1));
         }
      }
      
      public function get invitePlayers_lst() : List
      {
         return this._1281862409invitePlayers_lst;
      }
      
      private function _InvitePlayersView_DefaultListEffect2_i() : DefaultListEffect
      {
         var _loc1_:DefaultListEffect = new DefaultListEffect();
         this.chatListChangeEffect = _loc1_;
         _loc1_.color = 2236962;
         return _loc1_;
      }
      
      public function set availableColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._52801665availableColumn;
         if(_loc2_ !== param1)
         {
            this._52801665availableColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableColumn",_loc2_,param1));
         }
      }
      
      public function get invitePlayerByName_btn() : Button
      {
         return this._705980169invitePlayerByName_btn;
      }
      
      public function set invitePlayers_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1281871994invitePlayers_btn;
         if(_loc2_ !== param1)
         {
            this._1281871994invitePlayers_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invitePlayers_btn",_loc2_,param1));
         }
      }
      
      private function handleAddPlayerInviteEvent(param1:InviteBayEvent) : void
      {
         this.updateGuestSlotCount();
         this._addPlayerInviteClickedSignal.dispatch([param1.rosterItem]);
      }
      
      private function _InvitePlayersView_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.availableColumn = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"availableColumn");
         return _loc1_;
      }
      
      public function get listChangeEffect() : DefaultListEffect
      {
         return this._2049260831listChangeEffect;
      }
      
      public function get deactivateEffect() : Parallel
      {
         return this._616451877deactivateEffect;
      }
      
      public function set chatListChangeEffect(param1:DefaultListEffect) : void
      {
         var _loc2_:Object = this._1895195799chatListChangeEffect;
         if(_loc2_ !== param1)
         {
            this._1895195799chatListChangeEffect = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatListChangeEffect",_loc2_,param1));
         }
      }
      
      public function get invitePlayersClose_btn() : Button
      {
         return this._1058326740invitePlayersClose_btn;
      }
      
      private function onCreationComplete() : void
      {
         this.filters = [this.glowFilter];
         this.isBusy = false;
         this.activateEffect.end();
         this.activateEffect.play();
         this.updateSelectionIndex();
         this.addEventListener(InviteBayEvent.ADD_PLAYER,this.handleAddPlayerInviteEvent,false,0,true);
         this.addEventListener(InviteBayEvent.REMOVE_PLAYER,this.handleRemovePlayerInviteEvent,false,0,true);
         this._guestSlotsEnabledConfig = DynamicClientConfigManager.getConfiguration(GuestSlotsConfig.NAMESPACE,GuestSlotsConfig.ENABLED,false,this.onEnabledChanged);
         this.teamGuestSlotsEnabled = this._guestSlotsEnabledConfig.getValue();
         this.updateGuestSlotCount();
      }
      
      public function set filter_ti(param1:PromptingTextInput) : void
      {
         var _loc2_:Object = this._881372004filter_ti;
         if(_loc2_ !== param1)
         {
            this._881372004filter_ti = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filter_ti",_loc2_,param1));
         }
      }
      
      public function ___InvitePlayersView_Canvas1_addedToStage(param1:Event) : void
      {
         this.onInjection();
      }
      
      public function get availPlayers_lbl() : WingedHeader
      {
         return this._282063162availPlayers_lbl;
      }
      
      private function _InvitePlayersView_DefaultListEffect1_i() : DefaultListEffect
      {
         var _loc1_:DefaultListEffect = new DefaultListEffect();
         this.listChangeEffect = _loc1_;
         _loc1_.color = 2236962;
         return _loc1_;
      }
      
      private function get _numGuestSlotsUsed() : int
      {
         return this._634955967_numGuestSlotsUsed;
      }
      
      public function set guestSlots_cb(param1:CheckBox) : void
      {
         var _loc2_:Object = this._397955935guestSlots_cb;
         if(_loc2_ !== param1)
         {
            this._397955935guestSlots_cb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"guestSlots_cb",_loc2_,param1));
         }
      }
      
      public function get inviteeList() : List
      {
         return this._1499317958inviteeList;
      }
      
      private function _InvitePlayersView_Fade2_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 800;
         _loc1_.alphaFrom = 1;
         _loc1_.alphaTo = 0;
         return _loc1_;
      }
      
      private function set selectionIndex(param1:int) : void
      {
         var _loc2_:Object = this._2147164506selectionIndex;
         if(_loc2_ !== param1)
         {
            this._2147164506selectionIndex = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectionIndex",_loc2_,param1));
         }
      }
      
      public function set playerLists_vs(param1:Canvas) : void
      {
         var _loc2_:Object = this._1984395688playerLists_vs;
         if(_loc2_ !== param1)
         {
            this._1984395688playerLists_vs = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerLists_vs",_loc2_,param1));
         }
      }
      
      public function ___InvitePlayersView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function getAddPlayerInviteClickedSignal() : ISignal
      {
         return this._addPlayerInviteClickedSignal;
      }
      
      public function get isRankedSoloQueue() : Boolean
      {
         return this._isRankedSoloQueue;
      }
      
      private function onInviteesChanged() : void
      {
         this.inviteeList.dataProvider = this._inviteRules.availableInvitees;
      }
      
      public function __inviteeList_dragEnter(param1:DragEvent) : void
      {
         this.onDragEvent(param1);
      }
      
      public function set availablePlayers_cb(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1522088373availablePlayers_cb;
         if(_loc2_ !== param1)
         {
            this._1522088373availablePlayers_cb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availablePlayers_cb",_loc2_,param1));
         }
      }
      
      private function get _numGuestSlots() : int
      {
         return this._1154107748_numGuestSlots;
      }
      
      private function onSectionNamesCollectionChanged(param1:CollectionEvent) : void
      {
         this.updateSelectionIndex();
      }
      
      private function set _inviteRules(param1:IInviteBayRules) : void
      {
         var _loc2_:Object = this._2137684561_inviteRules;
         if(_loc2_ !== param1)
         {
            this._2137684561_inviteRules = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_inviteRules",_loc2_,param1));
         }
      }
      
      public function __inviteeList_dragOver(param1:DragEvent) : void
      {
         this.onDragEvent(param1);
      }
      
      public function set inviteColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._175193153inviteColumn;
         if(_loc2_ !== param1)
         {
            this._175193153inviteColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteColumn",_loc2_,param1));
         }
      }
      
      public function get availableColumn() : ConstraintColumn
      {
         return this._52801665availableColumn;
      }
      
      public function getFilterTextChangedSignal() : ISignal
      {
         return this._filterTextChangedSignal;
      }
      
      public function __inviteeList_dragDrop(param1:DragEvent) : void
      {
         this.onDragDropRemove(param1);
      }
      
      private function isDragDropEnabledForItems(param1:DragEvent) : Boolean
      {
         var _loc2_:RosterItemVO = null;
         for each(_loc2_ in param1.dragSource.dataForFormat("items") as Array)
         {
            if(Boolean(_loc2_.isDuoQueueRestricted) || Boolean(_loc2_.isRankedRestricted))
            {
               return false;
            }
         }
         return true;
      }
      
      public function get invitePlayers_btn() : Button
      {
         return this._1281871994invitePlayers_btn;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:InvitePlayersView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._InvitePlayersView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_pvpnet_invite_legacy_view_InvitePlayersViewWatcherSetupUtil");
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
      
      public function __inviteeList_initialize(param1:FlexEvent) : void
      {
         this.onInviteeListInitialize();
      }
      
      private function _InvitePlayersView_Fade1_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 300;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         return _loc1_;
      }
      
      public function get playerLists_vs() : Canvas
      {
         return this._1984395688playerLists_vs;
      }
      
      public function __invitePlayers_btn_click(param1:MouseEvent) : void
      {
         this.onInvitePlayersClicked();
      }
      
      public function setInviteRules(param1:IInviteBayRules) : void
      {
         if(param1 == this._inviteRules)
         {
            return;
         }
         if(this._inviteRules)
         {
            this._inviteRules.getSectionLockedChangedSignal().remove(this.onSectionLockedChanged);
            this._inviteRules.getAvailableInviteesChangedSignal().remove(null);
         }
         this._inviteRules = param1;
         if(this._inviteRules)
         {
            this._inviteRules.getSectionLockedChangedSignal().add(this.onSectionLockedChanged);
            this._inviteRules.getAvailableInviteesChangedSignal().add(this.onInviteesChanged);
         }
      }
      
      public function get availablePlayers_cb() : ComboBox
      {
         return this._1522088373availablePlayers_cb;
      }
      
      private function get _inviteRules() : IInviteBayRules
      {
         return this._2137684561_inviteRules;
      }
      
      private function onInjection() : void
      {
         this._inviteRules.getNumGuestSlotsChangedSignal().add(this.updateGuestSlotCount);
         this.updateSelectionIndex();
      }
      
      public function __invitePlayers_lst_initialize(param1:FlexEvent) : void
      {
         this.onInvitePlayersListInitialize();
      }
      
      public function set invitePlayers_lbl(param1:WingedHeader) : void
      {
         var _loc2_:Object = this._1281862944invitePlayers_lbl;
         if(_loc2_ !== param1)
         {
            this._1281862944invitePlayers_lbl = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invitePlayers_lbl",_loc2_,param1));
         }
      }
      
      public function getInviteAllClickedSignal() : ISignal
      {
         return this._inviteAllClickedSignal;
      }
      
      private function _InvitePlayersView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this;
         _loc1_ = this;
         _loc1_ = this.playerLists_vs.x;
         _loc1_ = this.height * 0.18;
         _loc1_ = resourceManager.getString("resources","invitePlayers_playerFilterPrompt");
         _loc1_ = this._inviteRules.sectionType != InviteSectionTypeEnums.SECTION_TYPE_COMBOBOX;
         _loc1_ = this.playerLists_vs.x;
         _loc1_ = this.height * 0.18;
         _loc1_ = this.selectionIndex;
         _loc1_ = this._inviteRules.sectionType == InviteSectionTypeEnums.SECTION_TYPE_COMBOBOX;
         _loc1_ = !this._inviteRules.sectionLocked;
         _loc1_ = this._inviteRules.sectionNames;
         _loc1_ = this._inviteRules.sectionLocked ? this._inviteRules.sectionLockedTooltip : "";
         _loc1_ = this.playerLists_vs.x + 310;
         _loc1_ = this.height * 0.18;
         _loc1_ = this._inviteRules.sectionType == InviteSectionTypeEnums.SECTION_TYPE_COMBOBOX && this.teamGuestSlotsEnabled && ClientConfig.instance.leagueServiceEnabled;
         _loc1_ = this._numGuestSlots > 0;
         _loc1_ = resourceManager.getString("resources","invitePlayers_guestSlots",[this._numGuestSlotsUsed,this._numGuestSlots]);
         _loc1_ = resourceManager.getString("resources","invitePlayers_title_label");
         _loc1_ = WingedHeader.ORANGE;
         _loc1_ = resourceManager.getString("resources","invitePlayers_subtitle_label");
         _loc1_ = WingedHeader.YELLOW;
         _loc1_ = this.height - this.filter_ti.y;
         _loc1_ = resourceManager.getString("resources","invitePlayers_availablePlayersHeader_label");
         _loc1_ = this.filter_ti.y + this.filter_ti.height + 8;
         _loc1_ = this.height - this.chooseAvailPlayersLst_btnbar.y;
         _loc1_ = this.availableColumn.width * 0.85;
         _loc1_ = this._inviteRules.availableInvitees;
         _loc1_ = this.invitePlayers_lst.x;
         _loc1_ = this.height * 0.18;
         _loc1_ = this._inviteRules.allowInviteByName;
         _loc1_ = this.invitePlayerByName_ti.x + 305;
         _loc1_ = this.height * 0.18;
         _loc1_ = resourceManager.getString("resources","invitePlayers_invitePlayerByNameButton_label");
         _loc1_ = resourceManager.getString("resources","invitePlayers_invitePlayerByNameButton_tooltip");
         _loc1_ = this.invitePlayerByName_ti.text.length > 0 && !this.isBusy;
         _loc1_ = this._inviteRules.allowInviteByName;
         _loc1_ = this.availPlayers_lbl.y;
         _loc1_ = WingedHeader.ORANGE;
         _loc1_ = resourceManager.getString("resources","invitePlayers_inviteListHeader_label",["(" + this._inviteRules.availableInviteBay.length + "/" + InviteBayController.MAX_NUM_INVITE_BAY_PLAYERS + ")"]);
         _loc1_ = this.filter_ti.y + this.filter_ti.height + 8;
         _loc1_ = this.height - this.chooseAvailPlayersLst_btnbar.y;
         _loc1_ = this.inviteColumn.width * 0.85;
         _loc1_ = this._inviteRules.availableInviteBay;
         _loc1_ = this.selectionIndex;
         _loc1_ = this._inviteRules.sectionType == InviteSectionTypeEnums.SECTION_TYPE_TABS;
         _loc1_ = !this._inviteRules.sectionLocked;
         _loc1_ = this._inviteRules.sectionNames;
         _loc1_ = resourceManager.getString("resources","invitePlayers_closeWindowButton_tooltip");
         _loc1_ = resourceManager.getString("resources","invitePlayers_invitePlayersButton_label");
         _loc1_ = resourceManager.getString("resources","invitePlayers_invitePlayersButton_tooltip");
         _loc1_ = this._inviteRules.availableInviteBay.length > 0 && !this.isBusy;
      }
      
      private function onInviteeListInitialize() : void
      {
         if(this.teamGuestSlotsEnabled)
         {
            InvitePlayerCardFactory.instance.assetsLoaded.add(this.setAvailableInviteListRenderer);
            if(InvitePlayerCardFactory.instance.haveAssetsLoaded)
            {
               this.setAvailableInviteListRenderer();
            }
         }
         else
         {
            this.inviteeList.itemRenderer = new ClassFactory(InviteBayPlayersViewRenderer);
            (this.inviteeList.itemRenderer as ClassFactory).properties = {
               "isAddBuddy":true,
               "isRankedSoloQueue":this._isRankedSoloQueue
            };
         }
      }
      
      public function get inviteColumn() : ConstraintColumn
      {
         return this._175193153inviteColumn;
      }
      
      public function getInvitePlayerClickedSignal() : ISignal
      {
         return this._invitePlayerClickedSignal;
      }
      
      private function updateSelectionIndex() : void
      {
         var _loc1_:int = -1;
         if(Boolean(this._inviteRules) && Boolean(this._inviteRules.sectionNames))
         {
            _loc1_ = int(this._inviteRules.sectionIndex);
            if(_loc1_ >= this._inviteRules.sectionNames.length)
            {
               _loc1_ = this._inviteRules.sectionNames.length - 1;
            }
            this._inviteRules.getSectionChangedSignal().add(this.updateSelectionIndex);
            this._inviteRules.sectionNames.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSectionNamesCollectionChanged);
         }
         this.selectionIndex = _loc1_;
         this.updateGuestSlotCount();
      }
      
      private function setInvitedPlayersListRenderer() : void
      {
         this.invitePlayers_lst.itemRenderer = InvitePlayerCardFactory.createRendererFactory({
            "isAddBuddy":false,
            "inviteRules":this._inviteRules
         });
      }
      
      private function updateGuestSlotCount() : void
      {
         this._numGuestSlots = this._inviteRules.numGuestSlots;
         this._numGuestSlotsUsed = this._inviteRules.numGuestSlotsUsed;
      }
      
      private function onSectionLockedChanged() : void
      {
         if(this.availablePlayers_cb)
         {
            this.availablePlayers_cb.enabled = !this._inviteRules.sectionLocked;
         }
      }
      
      private function _InvitePlayersView_Parallel2_i() : Parallel
      {
         var _loc1_:Parallel = new Parallel();
         this.deactivateEffect = _loc1_;
         _loc1_.children = [this._InvitePlayersView_Fade2_c()];
         _loc1_.addEventListener("effectEnd",this.__deactivateEffect_effectEnd);
         BindingManager.executeBindings(this,"deactivateEffect",this.deactivateEffect);
         return _loc1_;
      }
      
      private function doTextFilter(param1:Event) : void
      {
         this._filterTextChangedSignal.dispatch(this.filter_ti.text);
      }
      
      private function onEnabledChanged() : void
      {
         this.teamGuestSlotsEnabled = this._guestSlotsEnabledConfig.getValue();
      }
      
      public function set invitePlayers_lst(param1:List) : void
      {
         var _loc2_:Object = this._1281862409invitePlayers_lst;
         if(_loc2_ !== param1)
         {
            this._1281862409invitePlayers_lst = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invitePlayers_lst",_loc2_,param1));
         }
      }
      
      private function onInvitePlayersClicked() : void
      {
         this._inviteAllClickedSignal.dispatch();
         this.isBusy = true;
         this.playDeactivateEffect();
      }
      
      private function onDragDropAdd(param1:DragEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
         if(param1.dragSource.hasFormat("items"))
         {
            this.updateGuestSlotCount();
            this._addPlayerInviteClickedSignal.dispatch(param1.dragSource.dataForFormat("items") as Array);
         }
      }
   }
}

