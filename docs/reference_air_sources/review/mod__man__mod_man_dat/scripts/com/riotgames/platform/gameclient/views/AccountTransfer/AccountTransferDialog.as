package com.riotgames.platform.gameclient.views.AccountTransfer
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.components.MessageDialogTemplate;
   import com.riotgames.platform.gameclient.domain.accountState.AccountStateChangeContext;
   import com.riotgames.platform.gameclient.views.game.common.ICancelableDialog;
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
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class AccountTransferDialog extends Canvas implements ICancelableDialog, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      mx_internal var _watchers:Array = [];
      
      public const STYLE_BODY:String = "popupMessageBody";
      
      private var onClosed:Signal = new Signal();
      
      private var _447426607descriptionBox:VBox;
      
      private var _248346787status_txt:Text;
      
      private var _1852186835action_btn:Button;
      
      private var _986191789description_txt:Text;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":MessageDialogTemplate,
               "id":"container",
               "propertiesFactory":function():Object
               {
                  return {
                     "contentRow":_AccountTransferDialog_VBox1_i(),
                     "buttonRow":[_AccountTransferDialog_Button1_i()]
                  };
               }
            })]};
         }
      });
      
      private var _410956671container:MessageDialogTemplate;
      
      public function AccountTransferDialog()
      {
         super();
         mx_internal::_document = this;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         AccountTransferDialog._watcherSetupUtil = param1;
      }
      
      private function getMigrationStatusCodeDisplayString(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:String = resourceManager.getString("resources","transfer_service_migration_code_message_" + param1,[param2,param3]);
         if(_loc4_ == null)
         {
            _loc4_ = resourceManager.getString("resources","transfer_service_migration_code_message_unknown",[param2,param3,param1]);
         }
         return _loc4_;
      }
      
      [Bindable(event="propertyChange")]
      public function get container() : MessageDialogTemplate
      {
         return this._410956671container;
      }
      
      public function set container(param1:MessageDialogTemplate) : void
      {
         var _loc2_:Object = this._410956671container;
         if(_loc2_ !== param1)
         {
            this._410956671container = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"container",_loc2_,param1));
         }
      }
      
      public function setTransferFailed(param1:AccountStateChangeContext) : void
      {
         var _loc2_:String = this.getRegionDisplayName(param1.sourcePlatformId);
         var _loc3_:String = this.getRegionDisplayName(param1.destinationPlatformId);
         var _loc4_:String = this.getMigrationStatusCodeDisplayString(param1.migrationStatusCode,_loc2_,_loc3_);
         this.setStatusText(resourceManager.getString("resources","transfer_service_dialog_progress_transfer_failed",[_loc2_,_loc3_,_loc4_]));
         this.makeActionButtonResume();
      }
      
      private function _AccountTransferDialog_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         this.action_btn = _loc1_;
         _loc1_.label = "";
         _loc1_.visible = false;
         _loc1_.addEventListener("click",this.__action_btn_click);
         _loc1_.id = "action_btn";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:AccountTransferDialog = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._AccountTransferDialog_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_AccountTransfer_AccountTransferDialogWatcherSetupUtil");
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
      
      public function setTransferUnknown() : void
      {
         this.setStatusText(resourceManager.getString("resources","transfer_service_dialog_progress_status_unknown"));
         this.makeActionButtonLogout();
      }
      
      private function onButtonClick() : void
      {
         this.onClosed.dispatch(this.onClosed);
      }
      
      public function getOnClosed() : ISignal
      {
         return this.onClosed;
      }
      
      private function getRegionDisplayName(param1:String) : String
      {
         var _loc2_:String = resourceManager.getString("resources","transfer_service_region_" + param1);
         if(_loc2_ == null)
         {
            _loc2_ = param1;
         }
         return _loc2_;
      }
      
      public function set action_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1852186835action_btn;
         if(_loc2_ !== param1)
         {
            this._1852186835action_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"action_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get status_txt() : Text
      {
         return this._248346787status_txt;
      }
      
      [Bindable(event="propertyChange")]
      public function get description_txt() : Text
      {
         return this._986191789description_txt;
      }
      
      private function _AccountTransferDialog_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = resourceManager.getString("resources","transfer_service_dialog_title");
         _loc1_ = resourceManager.getString("resources","transfer_service_description");
         _loc1_ = this.STYLE_BODY;
         _loc1_ = this.STYLE_BODY;
      }
      
      private function _AccountTransferDialog_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         this.description_txt = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.id = "description_txt";
         BindingManager.executeBindings(this,"description_txt",this.description_txt);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get descriptionBox() : VBox
      {
         return this._447426607descriptionBox;
      }
      
      private function makeActionButtonLogout() : void
      {
         this.action_btn.label = resourceManager.getString("resources","transfer_service_dialog_logout_button_label");
         this.action_btn.enabled = true;
         this.action_btn.visible = true;
      }
      
      private function setStatusText(param1:String) : void
      {
         this.status_txt.text = resourceManager.getString("resources","transfer_service_dialog_progress_prefix") + " " + param1;
      }
      
      public function set status_txt(param1:Text) : void
      {
         var _loc2_:Object = this._248346787status_txt;
         if(_loc2_ !== param1)
         {
            this._248346787status_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"status_txt",_loc2_,param1));
         }
      }
      
      private function _AccountTransferDialog_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","transfer_service_dialog_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            container.headerText = param1;
         },"container.headerText");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","transfer_service_description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            description_txt.text = param1;
         },"description_txt.text");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BODY;
         },function(param1:Object):void
         {
            description_txt.styleName = param1;
         },"description_txt.styleName");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BODY;
         },function(param1:Object):void
         {
            status_txt.styleName = param1;
         },"status_txt.styleName");
         result[3] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get action_btn() : Button
      {
         return this._1852186835action_btn;
      }
      
      public function setTransferStarted() : void
      {
         this.setStatusText(resourceManager.getString("resources","transfer_service_dialog_progress_transferring"));
         this.action_btn.visible = false;
      }
      
      public function setTransferCompleted(param1:AccountStateChangeContext) : void
      {
         var _loc2_:String = this.getRegionDisplayName(param1.sourcePlatformId);
         var _loc3_:String = this.getRegionDisplayName(param1.destinationPlatformId);
         var _loc4_:String = this.getMigrationStatusCodeDisplayString(param1.migrationStatusCode,_loc2_,_loc3_);
         this.setStatusText(resourceManager.getString("resources","transfer_service_dialog_progress_transfer_complete",[_loc2_,_loc3_,_loc4_]));
         this.makeActionButtonLogout();
      }
      
      public function set description_txt(param1:Text) : void
      {
         var _loc2_:Object = this._986191789description_txt;
         if(_loc2_ !== param1)
         {
            this._986191789description_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description_txt",_loc2_,param1));
         }
      }
      
      private function makeActionButtonResume() : void
      {
         this.action_btn.label = resourceManager.getString("resources","transfer_service_dialog_resume_button_label");
         this.action_btn.enabled = true;
         this.action_btn.visible = true;
      }
      
      public function set descriptionBox(param1:VBox) : void
      {
         var _loc2_:Object = this._447426607descriptionBox;
         if(_loc2_ !== param1)
         {
            this._447426607descriptionBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"descriptionBox",_loc2_,param1));
         }
      }
      
      private function _AccountTransferDialog_VBox1_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         this.descriptionBox = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.setStyle("paddingLeft",10);
         _loc1_.setStyle("paddingRight",10);
         _loc1_.setStyle("verticalGap",20);
         _loc1_.setStyle("horizontalAlign","center");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.id = "descriptionBox";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._AccountTransferDialog_Text1_i());
         _loc1_.addChild(this._AccountTransferDialog_Text2_i());
         return _loc1_;
      }
      
      private function _AccountTransferDialog_Text2_i() : Text
      {
         var _loc1_:Text = new Text();
         this.status_txt = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("textAlign","left");
         _loc1_.id = "status_txt";
         BindingManager.executeBindings(this,"status_txt",this.status_txt);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function cancel() : void
      {
      }
      
      public function __action_btn_click(param1:MouseEvent) : void
      {
         this.onButtonClick();
      }
   }
}

