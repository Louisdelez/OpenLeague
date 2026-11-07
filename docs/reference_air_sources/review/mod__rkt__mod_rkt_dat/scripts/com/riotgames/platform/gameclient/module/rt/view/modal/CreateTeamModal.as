package com.riotgames.platform.gameclient.module.rt.view.modal
{
   import com.riotgames.platform.common.components.MessagePopupTemplate;
   import com.riotgames.platform.common.components.controls.TextInput;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
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
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class CreateTeamModal extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1701131159txtNameInfo:Label;
      
      public var _CreateTeamModal_Label1:Label;
      
      public var _CreateTeamModal_Label2:Label;
      
      private var _988604533showNameText:String = "";
      
      private var _1245934296txtTagInfo:Label;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":VBox,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":MessagePopupTemplate,
               "id":"container",
               "propertiesFactory":function():Object
               {
                  return {
                     "useCustomStyles":true,
                     "width":520,
                     "contentRow":_CreateTeamModal_VBox2_i(),
                     "buttonRow":[_CreateTeamModal_SoundEffectButton3_i(),_CreateTeamModal_SoundEffectButton4_i()]
                  };
               }
            })]};
         }
      });
      
      public var _CreateTeamModal_Text1:Text;
      
      private var _349262255btnCheckTeamTag:SoundEffectButton;
      
      public var _CreateTeamModal_Text3:Text;
      
      public var _CreateTeamModal_Text2:Text;
      
      private var _1355957101txtTeamTag:TextInput;
      
      private var _568498112showNameError:Boolean = true;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _1639856981showTagError:Boolean = true;
      
      private var _117924854btnCancel:SoundEffectButton;
      
      private var _1160842710showTagText:String = "";
      
      private var _410956671container:MessagePopupTemplate;
      
      private var _272361984teamNameCanvas:Canvas;
      
      mx_internal var _watchers:Array = [];
      
      private var _2057593524btnCheckTeamName:SoundEffectButton;
      
      private var _1302969269teamTagCanvas:Canvas;
      
      private var _264524434contentBox:VBox;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      mx_internal var _bindings:Array = [];
      
      private var _1246049228txtTeamNameCreate:TextInput;
      
      private var _133355128btnCreate:SoundEffectButton;
      
      public function CreateTeamModal()
      {
         super();
         mx_internal::_document = this;
         this.addEventListener("creationComplete",this.___CreateTeamModal_VBox1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         CreateTeamModal._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamNameCanvas() : Canvas
      {
         return this._272361984teamNameCanvas;
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
      
      [Bindable(event="propertyChange")]
      public function get btnCancel() : SoundEffectButton
      {
         return this._117924854btnCancel;
      }
      
      private function _CreateTeamModal_Text3_i() : Text
      {
         var _loc1_:Text = new Text();
         this._CreateTeamModal_Text3 = _loc1_;
         _loc1_.x = 28;
         _loc1_.styleName = "popupMessageTitle";
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.id = "_CreateTeamModal_Text3";
         BindingManager.executeBindings(this,"_CreateTeamModal_Text3",this._CreateTeamModal_Text3);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function set teamNameCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._272361984teamNameCanvas;
         if(_loc2_ !== param1)
         {
            this._272361984teamNameCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamNameCanvas",_loc2_,param1));
         }
      }
      
      public function onNameError(param1:String) : void
      {
         this.showNameError = true;
      }
      
      private function _CreateTeamModal_SoundEffectButton3_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.btnCancel = _loc1_;
         _loc1_.buttonMode = true;
         _loc1_.styleName = "s1FormButton";
         _loc1_.id = "btnCancel";
         BindingManager.executeBindings(this,"btnCancel",this.btnCancel);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___CreateTeamModal_VBox1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
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
      
      private function _CreateTeamModal_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("createTeamHeader");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            container.headerText = param1;
         },"container.headerText");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("createTeamInstructions1");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _CreateTeamModal_Label1.text = param1;
         },"_CreateTeamModal_Label1.text");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("createTeamInstructions2");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _CreateTeamModal_Label2.text = param1;
         },"_CreateTeamModal_Label2.text");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("createTeamInstructions3");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _CreateTeamModal_Text1.text = param1;
         },"_CreateTeamModal_Text1.text");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("createTeamName");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _CreateTeamModal_Text2.text = param1;
         },"_CreateTeamModal_Text2.text");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("createTeamCheckName");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnCheckTeamName.label = param1;
         },"btnCheckTeamName.label");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("createTeamTag");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _CreateTeamModal_Text3.text = param1;
         },"_CreateTeamModal_Text3.text");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("createTeamCheckTag");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnCheckTeamTag.label = param1;
         },"btnCheckTeamTag.label");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("createTeamCancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnCancel.label = param1;
         },"btnCancel.label");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("createTeamCreate");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnCreate.label = param1;
         },"btnCreate.label");
         result[9] = binding;
         return result;
      }
      
      private function onTeamNameChanged() : void
      {
         this.showNameError = false;
      }
      
      private function _CreateTeamModal_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         this._CreateTeamModal_Label1 = _loc1_;
         _loc1_.y = 0;
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("fontSize",14);
         _loc1_.id = "_CreateTeamModal_Label1";
         BindingManager.executeBindings(this,"_CreateTeamModal_Label1",this._CreateTeamModal_Label1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function onTeamCreationComplete() : void
      {
         this.txtTeamNameCreate.setFocus();
      }
      
      private function onCreationComplete() : void
      {
         RTFacade.instance.registerMediator(new CreateTeamModalMediator(CreateTeamModalMediator.NAME,this));
      }
      
      [Bindable(event="propertyChange")]
      public function get showTagText() : String
      {
         return this._1160842710showTagText;
      }
      
      private function _CreateTeamModal_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = RTResource.getString("createTeamHeader");
         _loc1_ = RTResource.getString("createTeamInstructions1");
         _loc1_ = RTResource.getString("createTeamInstructions2");
         _loc1_ = RTResource.getString("createTeamInstructions3");
         _loc1_ = RTResource.getString("createTeamName");
         _loc1_ = RTResource.getString("createTeamCheckName");
         _loc1_ = RTResource.getString("createTeamTag");
         _loc1_ = RTResource.getString("createTeamCheckTag");
         _loc1_ = RTResource.getString("createTeamCancel");
         _loc1_ = RTResource.getString("createTeamCreate");
      }
      
      private function _CreateTeamModal_Text2_i() : Text
      {
         var _loc1_:Text = new Text();
         this._CreateTeamModal_Text2 = _loc1_;
         _loc1_.styleName = "popupMessageTitle";
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.id = "_CreateTeamModal_Text2";
         BindingManager.executeBindings(this,"_CreateTeamModal_Text2",this._CreateTeamModal_Text2);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get btnCheckTeamTag() : SoundEffectButton
      {
         return this._349262255btnCheckTeamTag;
      }
      
      private function _CreateTeamModal_SoundEffectButton2_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.btnCheckTeamTag = _loc1_;
         _loc1_.x = 265;
         _loc1_.y = 24;
         _loc1_.styleName = "s1FormButton";
         _loc1_.width = 160;
         _loc1_.id = "btnCheckTeamTag";
         BindingManager.executeBindings(this,"btnCheckTeamTag",this.btnCheckTeamTag);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get txtTeamNameCreate() : TextInput
      {
         return this._1246049228txtTeamNameCreate;
      }
      
      public function set showTagText(param1:String) : void
      {
         var _loc2_:Object = this._1160842710showTagText;
         if(_loc2_ !== param1)
         {
            this._1160842710showTagText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showTagText",_loc2_,param1));
         }
      }
      
      public function set showTagError(param1:Boolean) : void
      {
         var _loc2_:Object = this._1639856981showTagError;
         if(_loc2_ !== param1)
         {
            this._1639856981showTagError = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showTagError",_loc2_,param1));
         }
      }
      
      public function set btnCheckTeamName(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._2057593524btnCheckTeamName;
         if(_loc2_ !== param1)
         {
            this._2057593524btnCheckTeamName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnCheckTeamName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get txtNameInfo() : Label
      {
         return this._1701131159txtNameInfo;
      }
      
      public function set teamTagCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._1302969269teamTagCanvas;
         if(_loc2_ !== param1)
         {
            this._1302969269teamTagCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamTagCanvas",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get txtTeamTag() : TextInput
      {
         return this._1355957101txtTeamTag;
      }
      
      public function set txtTeamNameCreate(param1:TextInput) : void
      {
         var _loc2_:Object = this._1246049228txtTeamNameCreate;
         if(_loc2_ !== param1)
         {
            this._1246049228txtTeamNameCreate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"txtTeamNameCreate",_loc2_,param1));
         }
      }
      
      private function _CreateTeamModal_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         this.txtTagInfo = _loc1_;
         _loc1_.y = 60;
         _loc1_.setStyle("fontSize",14);
         _loc1_.id = "txtTagInfo";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get showNameText() : String
      {
         return this._988604533showNameText;
      }
      
      [Bindable(event="propertyChange")]
      public function get btnCreate() : SoundEffectButton
      {
         return this._133355128btnCreate;
      }
      
      private function _CreateTeamModal_Canvas3_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         this.teamTagCanvas = _loc1_;
         _loc1_.height = 100;
         _loc1_.percentWidth = 100;
         _loc1_.id = "teamTagCanvas";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._CreateTeamModal_Text3_i());
         _loc1_.addChild(this._CreateTeamModal_TextInput2_i());
         _loc1_.addChild(this._CreateTeamModal_SoundEffectButton2_i());
         _loc1_.addChild(this._CreateTeamModal_Label4_i());
         return _loc1_;
      }
      
      public function set showNameError(param1:Boolean) : void
      {
         var _loc2_:Object = this._568498112showNameError;
         if(_loc2_ !== param1)
         {
            this._568498112showNameError = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showNameError",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get container() : MessagePopupTemplate
      {
         return this._410956671container;
      }
      
      private function _CreateTeamModal_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         this._CreateTeamModal_Text1 = _loc1_;
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.y = 40;
         _loc1_.height = 60;
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("fontSize",14);
         _loc1_.id = "_CreateTeamModal_Text1";
         BindingManager.executeBindings(this,"_CreateTeamModal_Text1",this._CreateTeamModal_Text1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function onTagError(param1:String) : void
      {
         this.showTagError = true;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:CreateTeamModal = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._CreateTeamModal_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_module_rt_view_modal_CreateTeamModalWatcherSetupUtil");
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
      
      private function _CreateTeamModal_SoundEffectButton1_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.btnCheckTeamName = _loc1_;
         _loc1_.x = 265;
         _loc1_.y = 24;
         _loc1_.styleName = "s1FormButton";
         _loc1_.width = 160;
         _loc1_.id = "btnCheckTeamName";
         BindingManager.executeBindings(this,"btnCheckTeamName",this.btnCheckTeamName);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get contentBox() : VBox
      {
         return this._264524434contentBox;
      }
      
      public function set btnCheckTeamTag(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._349262255btnCheckTeamTag;
         if(_loc2_ !== param1)
         {
            this._349262255btnCheckTeamTag = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnCheckTeamTag",_loc2_,param1));
         }
      }
      
      private function _CreateTeamModal_TextInput2_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         this.txtTeamTag = _loc1_;
         _loc1_.y = 30;
         _loc1_.styleName = "standard";
         _loc1_.width = 250;
         _loc1_.maxChars = 6;
         _loc1_.addEventListener("change",this.__txtTeamTag_change);
         _loc1_.id = "txtTeamTag";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get showTagError() : Boolean
      {
         return this._1639856981showTagError;
      }
      
      public function set txtTagInfo(param1:Label) : void
      {
         var _loc2_:Object = this._1245934296txtTagInfo;
         if(_loc2_ !== param1)
         {
            this._1245934296txtTagInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"txtTagInfo",_loc2_,param1));
         }
      }
      
      private function _CreateTeamModal_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         this.txtNameInfo = _loc1_;
         _loc1_.y = 60;
         _loc1_.setStyle("fontSize",14);
         _loc1_.id = "txtNameInfo";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get btnCheckTeamName() : SoundEffectButton
      {
         return this._2057593524btnCheckTeamName;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamTagCanvas() : Canvas
      {
         return this._1302969269teamTagCanvas;
      }
      
      private function onTeamTagChanged() : void
      {
         this.showTagError = false;
      }
      
      private function _CreateTeamModal_Canvas2_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         this.teamNameCanvas = _loc1_;
         _loc1_.height = 90;
         _loc1_.percentWidth = 100;
         _loc1_.id = "teamNameCanvas";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._CreateTeamModal_Text2_i());
         _loc1_.addChild(this._CreateTeamModal_TextInput1_i());
         _loc1_.addChild(this._CreateTeamModal_SoundEffectButton1_i());
         _loc1_.addChild(this._CreateTeamModal_Label3_i());
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get showNameError() : Boolean
      {
         return this._568498112showNameError;
      }
      
      public function __txtTeamNameCreate_creationComplete(param1:FlexEvent) : void
      {
         this.onTeamCreationComplete();
      }
      
      public function set txtNameInfo(param1:Label) : void
      {
         var _loc2_:Object = this._1701131159txtNameInfo;
         if(_loc2_ !== param1)
         {
            this._1701131159txtNameInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"txtNameInfo",_loc2_,param1));
         }
      }
      
      private function _CreateTeamModal_SoundEffectButton4_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.btnCreate = _loc1_;
         _loc1_.buttonMode = true;
         _loc1_.styleName = "smallButtonOrange";
         _loc1_.id = "btnCreate";
         BindingManager.executeBindings(this,"btnCreate",this.btnCreate);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get txtTagInfo() : Label
      {
         return this._1245934296txtTagInfo;
      }
      
      public function set txtTeamTag(param1:TextInput) : void
      {
         var _loc2_:Object = this._1355957101txtTeamTag;
         if(_loc2_ !== param1)
         {
            this._1355957101txtTeamTag = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"txtTeamTag",_loc2_,param1));
         }
      }
      
      public function __txtTeamTag_change(param1:Event) : void
      {
         this.onTeamTagChanged();
      }
      
      private function _CreateTeamModal_TextInput1_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         this.txtTeamNameCreate = _loc1_;
         _loc1_.y = 30;
         _loc1_.styleName = "standard";
         _loc1_.width = 250;
         _loc1_.maxChars = 24;
         _loc1_.addEventListener("creationComplete",this.__txtTeamNameCreate_creationComplete);
         _loc1_.addEventListener("change",this.__txtTeamNameCreate_change);
         _loc1_.id = "txtTeamNameCreate";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function set showNameText(param1:String) : void
      {
         var _loc2_:Object = this._988604533showNameText;
         if(_loc2_ !== param1)
         {
            this._988604533showNameText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showNameText",_loc2_,param1));
         }
      }
      
      public function set btnCancel(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._117924854btnCancel;
         if(_loc2_ !== param1)
         {
            this._117924854btnCancel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnCancel",_loc2_,param1));
         }
      }
      
      public function set btnCreate(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._133355128btnCreate;
         if(_loc2_ !== param1)
         {
            this._133355128btnCreate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnCreate",_loc2_,param1));
         }
      }
      
      private function _CreateTeamModal_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         this._CreateTeamModal_Label2 = _loc1_;
         _loc1_.y = 20;
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("fontSize",14);
         _loc1_.id = "_CreateTeamModal_Label2";
         BindingManager.executeBindings(this,"_CreateTeamModal_Label2",this._CreateTeamModal_Label2);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CreateTeamModal_Canvas1_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.height = 120;
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._CreateTeamModal_Label1_i());
         _loc1_.addChild(this._CreateTeamModal_Label2_i());
         _loc1_.addChild(this._CreateTeamModal_Text1_i());
         return _loc1_;
      }
      
      public function __txtTeamNameCreate_change(param1:Event) : void
      {
         this.onTeamNameChanged();
      }
      
      private function _CreateTeamModal_VBox2_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         this.contentBox = _loc1_;
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.setStyle("paddingLeft",10);
         _loc1_.id = "contentBox";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._CreateTeamModal_Canvas1_c());
         _loc1_.addChild(this._CreateTeamModal_Canvas2_i());
         _loc1_.addChild(this._CreateTeamModal_Canvas3_i());
         return _loc1_;
      }
   }
}

