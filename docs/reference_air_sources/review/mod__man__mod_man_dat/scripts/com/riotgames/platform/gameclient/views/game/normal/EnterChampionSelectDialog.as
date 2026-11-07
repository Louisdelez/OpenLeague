package com.riotgames.platform.gameclient.views.game.normal
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.components.MessagePopupTemplate;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.utils.AnimationHelper;
   import com.riotgames.platform.gameclient.views.game.common.ICancelableDialog;
   import com.riotgames.pvpnet.game.domain.EnterChampionSelectManager;
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
   import mx.controls.Text;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class EnterChampionSelectDialog extends Canvas implements ICancelableDialog, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var onDismissed:Signal = new Signal();
      
      private var _1239547184enterChampionSelectManager:EnterChampionSelectManager;
      
      public const STYLE_BODY:String = "popupMessageBody";
      
      mx_internal var _watchers:Array = [];
      
      private var _720590664enterChampionSelection_btn:SoundEffectButton;
      
      private var onAccepted:Signal = new Signal();
      
      private var _264524434contentBox:VBox;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _1702988371body_txt:Text;
      
      public var _EnterChampionSelectDialog_Text2:Text;
      
      private var _2125394179finishWhatIWasDoing_btn:SoundEffectButton;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":500,
               "height":300,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":MessagePopupTemplate,
                  "id":"container",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleButton":"longButtonBlue",
                        "minWidth":400,
                        "contentRow":_EnterChampionSelectDialog_VBox1_i(),
                        "buttonRow":[_EnterChampionSelectDialog_SoundEffectButton1_i(),_EnterChampionSelectDialog_SoundEffectButton2_i()]
                     };
                  }
               })]
            };
         }
      });
      
      private var _410956671container:MessagePopupTemplate;
      
      public function EnterChampionSelectDialog()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.width = 500;
         this.height = 300;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("creationComplete",this.___EnterChampionSelectDialog_Canvas1_creationComplete);
         this.addEventListener("remove",this.___EnterChampionSelectDialog_Canvas1_remove);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EnterChampionSelectDialog._watcherSetupUtil = param1;
      }
      
      public function cancel() : void
      {
         this.onFinishWhatIWasDoingClicked();
      }
      
      public function ___EnterChampionSelectDialog_Canvas1_remove(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeOutEffect(this);
      }
      
      private function onFinishWhatIWasDoingClicked() : void
      {
         AnimationHelper.playFadeOutEffect(this);
         this.onDismissed.dispatch(this.onDismissed);
      }
      
      public function set container(param1:MessagePopupTemplate) : void
      {
         var _loc2_:Object = this._410956671container;
         if(_loc2_ !== param1)
         {
            this._410956671container = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"container",_loc2_,param1));
         }
      }
      
      private function _EnterChampionSelectDialog_SoundEffectButton2_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.enterChampionSelection_btn = _loc1_;
         _loc1_.setStyle("paddingRight",4);
         _loc1_.setStyle("paddingLeft",4);
         _loc1_.setStyle("paddingTop",4);
         _loc1_.setStyle("paddingBottom",4);
         _loc1_.addEventListener("click",this.__enterChampionSelection_btn_click);
         _loc1_.id = "enterChampionSelection_btn";
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
         var target:EnterChampionSelectDialog = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EnterChampionSelectDialog_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_normal_EnterChampionSelectDialogWatcherSetupUtil");
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
      
      [Bindable(event="propertyChange")]
      public function get container() : MessagePopupTemplate
      {
         return this._410956671container;
      }
      
      [Bindable(event="propertyChange")]
      public function get contentBox() : VBox
      {
         return this._264524434contentBox;
      }
      
      public function getOnAccepted() : ISignal
      {
         return this.onAccepted;
      }
      
      public function set contentBox(param1:VBox) : void
      {
         var _loc2_:Object = this._264524434contentBox;
         if(_loc2_ !== param1)
         {
            this._264524434contentBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentBox",_loc2_,param1));
         }
      }
      
      private function init() : void
      {
         this.finishWhatIWasDoing_btn.label = resourceManager.getString("resources","enterChampionSelect_FinishWhatIWasDoing");
         this.enterChampionSelection_btn.label = resourceManager.getString("resources","enterChampionSelect_NowEnterChampionSelect");
      }
      
      [Bindable(event="propertyChange")]
      public function get enterChampionSelectManager() : EnterChampionSelectManager
      {
         return this._1239547184enterChampionSelectManager;
      }
      
      public function __enterChampionSelection_btn_click(param1:MouseEvent) : void
      {
         this.onEnterChampionSelectionClicked();
      }
      
      public function set enterChampionSelection_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._720590664enterChampionSelection_btn;
         if(_loc2_ !== param1)
         {
            this._720590664enterChampionSelection_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enterChampionSelection_btn",_loc2_,param1));
         }
      }
      
      private function _EnterChampionSelectDialog_VBox1_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         this.contentBox = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.height = 62;
         _loc1_.verticalScrollPolicy = "off";
         _loc1_.horizontalScrollPolicy = "off";
         _loc1_.setStyle("paddingLeft",10);
         _loc1_.setStyle("paddingRight",10);
         _loc1_.setStyle("verticalGap",8);
         _loc1_.setStyle("horizontalAlign","center");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.id = "contentBox";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._EnterChampionSelectDialog_Text1_i());
         _loc1_.addChild(this._EnterChampionSelectDialog_Text2_i());
         return _loc1_;
      }
      
      public function set body_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1702988371body_txt;
         if(_loc2_ !== param1)
         {
            this._1702988371body_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"body_txt",_loc2_,param1));
         }
      }
      
      private function _EnterChampionSelectDialog_Text2_i() : Text
      {
         var _loc1_:Text = new Text();
         this._EnterChampionSelectDialog_Text2 = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.id = "_EnterChampionSelectDialog_Text2";
         BindingManager.executeBindings(this,"_EnterChampionSelectDialog_Text2",this._EnterChampionSelectDialog_Text2);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function set finishWhatIWasDoing_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._2125394179finishWhatIWasDoing_btn;
         if(_loc2_ !== param1)
         {
            this._2125394179finishWhatIWasDoing_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"finishWhatIWasDoing_btn",_loc2_,param1));
         }
      }
      
      private function _EnterChampionSelectDialog_SoundEffectButton1_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.finishWhatIWasDoing_btn = _loc1_;
         _loc1_.setStyle("paddingRight",4);
         _loc1_.setStyle("paddingLeft",4);
         _loc1_.setStyle("paddingTop",4);
         _loc1_.setStyle("paddingBottom",4);
         _loc1_.addEventListener("click",this.__finishWhatIWasDoing_btn_click);
         _loc1_.id = "finishWhatIWasDoing_btn";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get enterChampionSelection_btn() : SoundEffectButton
      {
         return this._720590664enterChampionSelection_btn;
      }
      
      public function getOnDismissed() : ISignal
      {
         return this.onDismissed;
      }
      
      private function _EnterChampionSelectDialog_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():IFlexDisplayObject
         {
            return this.enterChampionSelection_btn;
         },function(param1:IFlexDisplayObject):void
         {
            this.defaultButton = param1;
         },"this.defaultButton");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","enterChampionSelect_MatchFound");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            container.headerText = param1;
         },"container.headerText");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BODY;
         },function(param1:Object):void
         {
            body_txt.styleName = param1;
         },"body_txt.styleName");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","enterChampionSelect_EnterChampionSelect");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            body_txt.htmlText = param1;
         },"body_txt.htmlText");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return body_txt.height;
         },function(param1:Number):void
         {
            _EnterChampionSelectDialog_Text2.height = param1;
         },"_EnterChampionSelectDialog_Text2.height");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BODY;
         },function(param1:Object):void
         {
            _EnterChampionSelectDialog_Text2.styleName = param1;
         },"_EnterChampionSelectDialog_Text2.styleName");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = enterChampionSelectManager.timeRemainingStr;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EnterChampionSelectDialog_Text2.htmlText = param1;
         },"_EnterChampionSelectDialog_Text2.htmlText");
         result[6] = binding;
         return result;
      }
      
      private function onEnterChampionSelectionClicked() : void
      {
         AnimationHelper.playFadeOutEffect(this);
         this.onAccepted.dispatch(this.onAccepted);
      }
      
      public function set enterChampionSelectManager(param1:EnterChampionSelectManager) : void
      {
         var _loc2_:Object = this._1239547184enterChampionSelectManager;
         if(_loc2_ !== param1)
         {
            this._1239547184enterChampionSelectManager = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enterChampionSelectManager",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get body_txt() : Text
      {
         return this._1702988371body_txt;
      }
      
      public function __finishWhatIWasDoing_btn_click(param1:MouseEvent) : void
      {
         this.onFinishWhatIWasDoingClicked();
      }
      
      private function _EnterChampionSelectDialog_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.enterChampionSelection_btn;
         _loc1_ = resourceManager.getString("resources","enterChampionSelect_MatchFound");
         _loc1_ = this.STYLE_BODY;
         _loc1_ = resourceManager.getString("resources","enterChampionSelect_EnterChampionSelect");
         _loc1_ = this.body_txt.height;
         _loc1_ = this.STYLE_BODY;
         _loc1_ = this.enterChampionSelectManager.timeRemainingStr;
      }
      
      private function _EnterChampionSelectDialog_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         this.body_txt = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.id = "body_txt";
         BindingManager.executeBindings(this,"body_txt",this.body_txt);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___EnterChampionSelectDialog_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.init();
      }
      
      [Bindable(event="propertyChange")]
      public function get finishWhatIWasDoing_btn() : SoundEffectButton
      {
         return this._2125394179finishWhatIWasDoing_btn;
      }
   }
}

