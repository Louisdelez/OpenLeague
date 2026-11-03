package com.riotgames.platform.gameclient.views.application
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.common.validators.EmailInputValidator;
   import com.riotgames.platform.common.validators.StringInputValidator;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.error.MailError;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.logging.LogManager;
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
   import mx.containers.Form;
   import mx.containers.FormItem;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.controls.TextArea;
   import mx.controls.TextInput;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ValidationResultEvent;
   import mx.graphics.ImageSnapshot;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   import org.bytearray.smtp.encoding.JPEGEncoder;
   
   use namespace mx_internal;
   
   public class SubmitLogsDialog extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1977861566header_txt:Text;
      
      private var _1376248119submitLogs_frm:Form;
      
      private var _1376251900submitLogs_btn:Button;
      
      private var _1263930823stringInputValidator2:StringInputValidator;
      
      private var _791226834screenSnapshot_chb:CheckBox;
      
      private var onClosed:Signal;
      
      private var _158633316emailInputValidator:EmailInputValidator;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var filenames:Array;
      
      private var _1186820151logManager:LogManager;
      
      private var _357091091problemDescription_txta:TextArea;
      
      private var _1433116989clipboardImage_chb:CheckBox;
      
      public var _SubmitLogsDialog_FormItem2:FormItem;
      
      public var _SubmitLogsDialog_FormItem1:FormItem;
      
      private var jpegEncoder:JPEGEncoder;
      
      mx_internal var _watchers:Array;
      
      private var _1553583249closeDialog2_btn:Button;
      
      private var _1526896890doesClipboardContainBitmap:Boolean;
      
      public var _SubmitLogsDialog_Label1:Label;
      
      private var attachments:Array;
      
      private var _1263930824stringInputValidator1:StringInputValidator;
      
      private var _1509340372subject_txti:TextInput;
      
      private var _880055555closeDialog_btn:SoundEffectButton;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _1192105760emailAddress_txti:TextInput;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function SubmitLogsDialog()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {
                  "width":600,
                  "height":600,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":mainframe,
                     "propertiesFactory":function():Object
                     {
                        return {
                           "x":0,
                           "y":0,
                           "percentHeight":100,
                           "percentWidth":100
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Text,
                     "id":"header_txt",
                     "stylesFactory":function():void
                     {
                        this.textAlign = "center";
                        this.fontFamily = "ApplicationFont1";
                        this.fontSize = 24;
                        this.color = 16777215;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "percentWidth":100,
                           "y":20
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Form,
                     "id":"submitLogs_frm",
                     "stylesFactory":function():void
                     {
                        this.left = "10";
                        this.right = "10";
                        this.verticalCenter = "0";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"childDescriptors":[new UIComponentDescriptor({
                           "type":FormItem,
                           "id":"_SubmitLogsDialog_FormItem1",
                           "stylesFactory":function():void
                           {
                              this.labelStyleName = "submitLogsFormLabel";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":TextInput,
                                    "id":"emailAddress_txti",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "maxChars":50,
                                          "percentWidth":50,
                                          "styleName":"whiteInput"
                                       };
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":FormItem,
                           "id":"_SubmitLogsDialog_FormItem2",
                           "stylesFactory":function():void
                           {
                              this.labelStyleName = "submitLogsFormLabel";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":TextInput,
                                    "id":"subject_txti",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "maxChars":100,
                                          "percentWidth":75,
                                          "styleName":"whiteInput"
                                       };
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"_SubmitLogsDialog_Label1",
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"submitLogsFormLabel"};
                           }
                        }),new UIComponentDescriptor({
                           "type":FormItem,
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":TextArea,
                                    "id":"problemDescription_txta",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "height":200,
                                          "percentWidth":100,
                                          "styleName":"whiteInput"
                                       };
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":CheckBox,
                           "id":"screenSnapshot_chb",
                           "propertiesFactory":function():Object
                           {
                              return {"labelPlacement":"right"};
                           }
                        }),new UIComponentDescriptor({
                           "type":CheckBox,
                           "id":"clipboardImage_chb",
                           "propertiesFactory":function():Object
                           {
                              return {"labelPlacement":"right"};
                           }
                        })]};
                     }
                  }),new UIComponentDescriptor({
                     "type":Button,
                     "id":"submitLogs_btn",
                     "events":{"click":"__submitLogs_btn_click"},
                     "stylesFactory":function():void
                     {
                        this.horizontalCenter = "-60";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "enabled":false,
                           "buttonMode":true,
                           "useHandCursor":true
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Button,
                     "id":"closeDialog2_btn",
                     "events":{"click":"__closeDialog2_btn_click"},
                     "stylesFactory":function():void
                     {
                        this.horizontalCenter = "60";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "buttonMode":true,
                           "useHandCursor":true
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"closeDialog_btn",
                     "events":{"click":"__closeDialog_btn_click"},
                     "stylesFactory":function():void
                     {
                        this.top = "10";
                        this.right = "10";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"chooseGameExitButton",
                           "buttonMode":true,
                           "useHandCursor":true
                        };
                     }
                  })]
               };
            }
         });
         this._1186820151logManager = LogManager.instance;
         this.onClosed = new Signal();
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
            this.backgroundAlpha = 0.75;
            this.backgroundColor = 0;
         };
         this.cacheAsBitmap = true;
         this.width = 600;
         this.height = 600;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this._SubmitLogsDialog_EmailInputValidator1_i();
         this._SubmitLogsDialog_StringInputValidator1_i();
         this._SubmitLogsDialog_StringInputValidator2_i();
         this.addEventListener("initialize",this.___SubmitLogsDialog_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SubmitLogsDialog._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get submitLogs_btn() : Button
      {
         return this._1376251900submitLogs_btn;
      }
      
      [Bindable(event="propertyChange")]
      private function get doesClipboardContainBitmap() : Boolean
      {
         return this._1526896890doesClipboardContainBitmap;
      }
      
      public function set submitLogs_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1376251900submitLogs_btn;
         if(_loc2_ !== param1)
         {
            this._1376251900submitLogs_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"submitLogs_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get problemDescription_txta() : TextArea
      {
         return this._357091091problemDescription_txta;
      }
      
      private function onSubmitLogsButtonClicked() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:BitmapData = null;
         var _loc3_:Clipboard = null;
         this.cursorManager.setBusyCursor();
         this.attachments = new Array();
         this.filenames = new Array();
         this.jpegEncoder = new JPEGEncoder();
         if(this.screenSnapshot_chb.selected)
         {
            this.visible = false;
            _loc1_ = ApplicationUtil.application as DisplayObject;
            _loc2_ = ImageSnapshot.captureBitmapData(_loc1_);
            this.attachments.push(this.jpegEncoder.encode(_loc2_));
            this.filenames.push("currentScreenshot.jpg");
            _loc2_.dispose();
            _loc2_ = null;
            this.visible = true;
         }
         if(this.clipboardImage_chb.selected)
         {
            _loc3_ = Clipboard.generalClipboard;
            _loc2_ = _loc3_.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData;
            this.attachments.push(this.jpegEncoder.encode(_loc2_));
            this.filenames.push("clipboardScreenshot.jpg");
            _loc2_.dispose();
            _loc2_ = null;
         }
         this.emailInputValidator.addEventListener(ValidationResultEvent.VALID,this.handleValidation,false,0,true);
         this.emailInputValidator.addEventListener(ValidationResultEvent.INVALID,this.handleValidation,false,0,true);
         this.emailInputValidator.validate();
      }
      
      private function onCloseDialogButtonClicked() : void
      {
         this.onClosed.dispatch(this.onClosed);
      }
      
      private function checkEnableButtonConditionMet(param1:Event) : void
      {
         if(this.subject_txti.text.length >= 1 && this.problemDescription_txta.text.length >= 1 && !this.logManager.getIsBusy())
         {
            this.submitLogs_btn.enabled = true;
         }
         else
         {
            this.submitLogs_btn.enabled = false;
         }
      }
      
      public function ___SubmitLogsDialog_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get emailAddress_txti() : TextInput
      {
         return this._1192105760emailAddress_txti;
      }
      
      private function set doesClipboardContainBitmap(param1:Boolean) : void
      {
         var _loc2_:Object = this._1526896890doesClipboardContainBitmap;
         if(_loc2_ !== param1)
         {
            this._1526896890doesClipboardContainBitmap = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"doesClipboardContainBitmap",_loc2_,param1));
         }
      }
      
      public function set problemDescription_txta(param1:TextArea) : void
      {
         var _loc2_:Object = this._357091091problemDescription_txta;
         if(_loc2_ !== param1)
         {
            this._357091091problemDescription_txta = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"problemDescription_txta",_loc2_,param1));
         }
      }
      
      private function _SubmitLogsDialog_StringInputValidator2_i() : StringInputValidator
      {
         var _loc1_:StringInputValidator = new StringInputValidator();
         this.stringInputValidator2 = _loc1_;
         _loc1_.property = "text";
         _loc1_.required = true;
         BindingManager.executeBindings(this,"stringInputValidator2",this.stringInputValidator2);
         _loc1_.initialized(this,"stringInputValidator2");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get screenSnapshot_chb() : CheckBox
      {
         return this._791226834screenSnapshot_chb;
      }
      
      [Bindable(event="propertyChange")]
      public function get stringInputValidator1() : StringInputValidator
      {
         return this._1263930824stringInputValidator1;
      }
      
      [Bindable(event="propertyChange")]
      public function get stringInputValidator2() : StringInputValidator
      {
         return this._1263930823stringInputValidator2;
      }
      
      [Bindable(event="propertyChange")]
      public function get subject_txti() : TextInput
      {
         return this._1509340372subject_txti;
      }
      
      public function set emailAddress_txti(param1:TextInput) : void
      {
         var _loc2_:Object = this._1192105760emailAddress_txti;
         if(_loc2_ !== param1)
         {
            this._1192105760emailAddress_txti = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"emailAddress_txti",_loc2_,param1));
         }
      }
      
      private function busyChangedHandler() : void
      {
         var _loc1_:Boolean = !this.logManager.getIsBusy();
         this.emailAddress_txti.editable = _loc1_;
         this.subject_txti.editable = _loc1_;
         this.problemDescription_txta.editable = _loc1_;
         this.screenSnapshot_chb.enabled = _loc1_;
         this.clipboardImage_chb.enabled = _loc1_;
         this.closeDialog_btn.enabled = _loc1_;
         this.checkEnableButtonConditionMet(new Event(Event.CHANGE,true));
      }
      
      private function _SubmitLogsDialog_StringInputValidator1_i() : StringInputValidator
      {
         var _loc1_:StringInputValidator = new StringInputValidator();
         this.stringInputValidator1 = _loc1_;
         _loc1_.property = "text";
         _loc1_.required = true;
         BindingManager.executeBindings(this,"stringInputValidator1",this.stringInputValidator1);
         _loc1_.initialized(this,"stringInputValidator1");
         return _loc1_;
      }
      
      public function set subject_txti(param1:TextInput) : void
      {
         var _loc2_:Object = this._1509340372subject_txti;
         if(_loc2_ !== param1)
         {
            this._1509340372subject_txti = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subject_txti",_loc2_,param1));
         }
      }
      
      public function set screenSnapshot_chb(param1:CheckBox) : void
      {
         var _loc2_:Object = this._791226834screenSnapshot_chb;
         if(_loc2_ !== param1)
         {
            this._791226834screenSnapshot_chb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"screenSnapshot_chb",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get emailInputValidator() : EmailInputValidator
      {
         return this._158633316emailInputValidator;
      }
      
      private function onLogSubmissionComplete(param1:Boolean) : void
      {
         this.cursorManager.removeBusyCursor();
         this.onClosed.dispatch(this.onClosed);
      }
      
      public function __submitLogs_btn_click(param1:MouseEvent) : void
      {
         this.onSubmitLogsButtonClicked();
      }
      
      [Bindable(event="propertyChange")]
      public function get closeDialog2_btn() : Button
      {
         return this._1553583249closeDialog2_btn;
      }
      
      public function set stringInputValidator1(param1:StringInputValidator) : void
      {
         var _loc2_:Object = this._1263930824stringInputValidator1;
         if(_loc2_ !== param1)
         {
            this._1263930824stringInputValidator1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stringInputValidator1",_loc2_,param1));
         }
      }
      
      public function set stringInputValidator2(param1:StringInputValidator) : void
      {
         var _loc2_:Object = this._1263930823stringInputValidator2;
         if(_loc2_ !== param1)
         {
            this._1263930823stringInputValidator2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stringInputValidator2",_loc2_,param1));
         }
      }
      
      private function onLogSubmissionError(param1:MailError) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","partnerBetaBlocked_title"),_loc2_.getString("resources",MessageDictionary.ERROR_SUBMITTING_LOGS,[param1.toString()]));
         _loc3_.add();
      }
      
      public function set header_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1977861566header_txt;
         if(_loc2_ !== param1)
         {
            this._1977861566header_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_txt",_loc2_,param1));
         }
      }
      
      public function set clipboardImage_chb(param1:CheckBox) : void
      {
         var _loc2_:Object = this._1433116989clipboardImage_chb;
         if(_loc2_ !== param1)
         {
            this._1433116989clipboardImage_chb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clipboardImage_chb",_loc2_,param1));
         }
      }
      
      public function set submitLogs_frm(param1:Form) : void
      {
         var _loc2_:Object = this._1376248119submitLogs_frm;
         if(_loc2_ !== param1)
         {
            this._1376248119submitLogs_frm = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"submitLogs_frm",_loc2_,param1));
         }
      }
      
      public function set logManager(param1:LogManager) : void
      {
         var _loc2_:Object = this._1186820151logManager;
         if(_loc2_ !== param1)
         {
            this._1186820151logManager = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logManager",_loc2_,param1));
         }
      }
      
      private function _SubmitLogsDialog_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogsDialogHeader");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            header_txt.htmlText = param1;
         },"header_txt.htmlText");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogs_emailAddressLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SubmitLogsDialog_FormItem1.label = param1;
         },"_SubmitLogsDialog_FormItem1.label");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogs_subjectLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SubmitLogsDialog_FormItem2.label = param1;
         },"_SubmitLogsDialog_FormItem2.label");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogs_descriptionOfProblemLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SubmitLogsDialog_Label1.htmlText = param1;
         },"_SubmitLogsDialog_Label1.htmlText");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogs_includeScreenSnapshotLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            screenSnapshot_chb.label = param1;
         },"screenSnapshot_chb.label");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogs_includeScreenSnapshot_toolTip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            screenSnapshot_chb.toolTip = param1;
         },"screenSnapshot_chb.toolTip");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogs_includeClipboardImageLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            clipboardImage_chb.label = param1;
         },"clipboardImage_chb.label");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogs_includeClipboardImage_toolTip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            clipboardImage_chb.toolTip = param1;
         },"clipboardImage_chb.toolTip");
         result[7] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.doesClipboardContainBitmap;
         },function(param1:Boolean):void
         {
            clipboardImage_chb.visible = param1;
         },"clipboardImage_chb.visible");
         result[8] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.doesClipboardContainBitmap;
         },function(param1:Boolean):void
         {
            clipboardImage_chb.includeInLayout = param1;
         },"clipboardImage_chb.includeInLayout");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogs_submitLogsButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            submitLogs_btn.label = param1;
         },"submitLogs_btn.label");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogs_submitLogsButton_toolTip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            submitLogs_btn.toolTip = param1;
         },"submitLogs_btn.toolTip");
         result[11] = binding;
         binding = new Binding(this,function():Number
         {
            return this.submitLogs_frm.y + this.submitLogs_frm.height + 10;
         },function(param1:Number):void
         {
            submitLogs_btn.y = param1;
         },"submitLogs_btn.y");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","common_button_cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            closeDialog2_btn.label = param1;
         },"closeDialog2_btn.label");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogs_closeButton_toolTip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            closeDialog2_btn.toolTip = param1;
         },"closeDialog2_btn.toolTip");
         result[14] = binding;
         binding = new Binding(this,function():Number
         {
            return this.submitLogs_frm.y + this.submitLogs_frm.height + 10;
         },function(param1:Number):void
         {
            closeDialog2_btn.y = param1;
         },"closeDialog2_btn.y");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","submitLogs_closeButton_toolTip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            closeDialog_btn.toolTip = param1;
         },"closeDialog_btn.toolTip");
         result[16] = binding;
         binding = new Binding(this,function():Object
         {
            return emailAddress_txti;
         },function(param1:Object):void
         {
            emailInputValidator.source = param1;
         },"emailInputValidator.source");
         result[17] = binding;
         binding = new Binding(this,function():Object
         {
            return subject_txti;
         },function(param1:Object):void
         {
            stringInputValidator1.source = param1;
         },"stringInputValidator1.source");
         result[18] = binding;
         binding = new Binding(this,function():Object
         {
            return problemDescription_txta;
         },function(param1:Object):void
         {
            stringInputValidator2.source = param1;
         },"stringInputValidator2.source");
         result[19] = binding;
         return result;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SubmitLogsDialog = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SubmitLogsDialog_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_application_SubmitLogsDialogWatcherSetupUtil");
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
      
      public function getOnClosed() : ISignal
      {
         return this.onClosed;
      }
      
      private function _SubmitLogsDialog_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = resourceManager.getString("resources","submitLogsDialogHeader");
         _loc1_ = resourceManager.getString("resources","submitLogs_emailAddressLabel");
         _loc1_ = resourceManager.getString("resources","submitLogs_subjectLabel");
         _loc1_ = resourceManager.getString("resources","submitLogs_descriptionOfProblemLabel");
         _loc1_ = resourceManager.getString("resources","submitLogs_includeScreenSnapshotLabel");
         _loc1_ = resourceManager.getString("resources","submitLogs_includeScreenSnapshot_toolTip");
         _loc1_ = resourceManager.getString("resources","submitLogs_includeClipboardImageLabel");
         _loc1_ = resourceManager.getString("resources","submitLogs_includeClipboardImage_toolTip");
         _loc1_ = this.doesClipboardContainBitmap;
         _loc1_ = this.doesClipboardContainBitmap;
         _loc1_ = resourceManager.getString("resources","submitLogs_submitLogsButtonLabel");
         _loc1_ = resourceManager.getString("resources","submitLogs_submitLogsButton_toolTip");
         _loc1_ = this.submitLogs_frm.y + this.submitLogs_frm.height + 10;
         _loc1_ = resourceManager.getString("resources","common_button_cancel");
         _loc1_ = resourceManager.getString("resources","submitLogs_closeButton_toolTip");
         _loc1_ = this.submitLogs_frm.y + this.submitLogs_frm.height + 10;
         _loc1_ = resourceManager.getString("resources","submitLogs_closeButton_toolTip");
         _loc1_ = this.emailAddress_txti;
         _loc1_ = this.subject_txti;
         _loc1_ = this.problemDescription_txta;
      }
      
      private function handleValidation(param1:ValidationResultEvent) : void
      {
         var _loc2_:String = null;
         if(param1.type == ValidationResultEvent.VALID)
         {
            _loc2_ = this.emailAddress_txti.text;
         }
         else
         {
            _loc2_ = "logsubmitter@pvpnetclient.com";
         }
         this.logManager.submitLogs(_loc2_,this.subject_txti.text,this.problemDescription_txta.text,this.attachments,this.filenames,this.onLogSubmissionComplete,this.onLogSubmissionError);
      }
      
      [Bindable(event="propertyChange")]
      public function get clipboardImage_chb() : CheckBox
      {
         return this._1433116989clipboardImage_chb;
      }
      
      public function __closeDialog2_btn_click(param1:MouseEvent) : void
      {
         this.onCloseDialogButtonClicked();
      }
      
      public function set emailInputValidator(param1:EmailInputValidator) : void
      {
         var _loc2_:Object = this._158633316emailInputValidator;
         if(_loc2_ !== param1)
         {
            this._158633316emailInputValidator = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"emailInputValidator",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get submitLogs_frm() : Form
      {
         return this._1376248119submitLogs_frm;
      }
      
      [Bindable(event="propertyChange")]
      public function get header_txt() : Text
      {
         return this._1977861566header_txt;
      }
      
      private function onInitialize() : void
      {
         var _loc1_:Clipboard = Clipboard.generalClipboard;
         this.doesClipboardContainBitmap = _loc1_.hasFormat(ClipboardFormats.BITMAP_FORMAT);
         this.subject_txti.addEventListener(Event.CHANGE,this.checkEnableButtonConditionMet);
         this.problemDescription_txta.addEventListener(Event.CHANGE,this.checkEnableButtonConditionMet);
         this.logManager.getIsBusyChanged().add(this.busyChangedHandler);
         this.busyChangedHandler();
      }
      
      [Bindable(event="propertyChange")]
      public function get logManager() : LogManager
      {
         return this._1186820151logManager;
      }
      
      public function set closeDialog2_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1553583249closeDialog2_btn;
         if(_loc2_ !== param1)
         {
            this._1553583249closeDialog2_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"closeDialog2_btn",_loc2_,param1));
         }
      }
      
      public function __closeDialog_btn_click(param1:MouseEvent) : void
      {
         this.onCloseDialogButtonClicked();
      }
      
      private function _SubmitLogsDialog_EmailInputValidator1_i() : EmailInputValidator
      {
         var _loc1_:EmailInputValidator = new EmailInputValidator();
         this.emailInputValidator = _loc1_;
         _loc1_.property = "text";
         BindingManager.executeBindings(this,"emailInputValidator",this.emailInputValidator);
         _loc1_.initialized(this,"emailInputValidator");
         return _loc1_;
      }
      
      public function set closeDialog_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._880055555closeDialog_btn;
         if(_loc2_ !== param1)
         {
            this._880055555closeDialog_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"closeDialog_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get closeDialog_btn() : SoundEffectButton
      {
         return this._880055555closeDialog_btn;
      }
   }
}

