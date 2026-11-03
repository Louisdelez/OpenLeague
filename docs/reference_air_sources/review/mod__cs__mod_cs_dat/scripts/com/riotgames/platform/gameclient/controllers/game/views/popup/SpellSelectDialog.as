package com.riotgames.platform.gameclient.controllers.game.views.popup
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertViewManager;
   import com.riotgames.platform.gameclient.controllers.game.commands.ISpellSelectDialog;
   import com.riotgames.platform.gameclient.controllers.game.event.SpellSelectEvent;
   import com.riotgames.platform.gameclient.controllers.game.views.SpellSelectRendererAS;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.views.game.common.ICancelableDialog;
   import com.riotgames.pvpnet.model.SpellSelection;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
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
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Spacer;
   import mx.controls.TileList;
   import mx.core.ClassFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class SpellSelectDialog extends Canvas implements ISpellSelectDialog, ICancelableDialog
   {
      
      public static const DIALOG_BASE_X:Number = 450;
      
      public static const DIALOG_BASE_Y:Number = 145;
      
      private var _1498797175spellsList:TileList;
      
      private var spell1:Spell;
      
      private var spell2:Spell;
      
      private var _1629054817selectionBox:HBox;
      
      private var _spellIndex:uint = 1;
      
      private var _2124508285spellBox:VBox;
      
      private var _spellProvider:ArrayCollection;
      
      private var _1856660100selectedSpell1:Image;
      
      private var spellProviderChanged:Boolean = false;
      
      protected var spellIndexChanged:Boolean = false;
      
      private var pendingSpell:Spell;
      
      private var _chooseBoth:Boolean = false;
      
      public var arrowedAlertViewManager:ArrowedAlertViewManager = null;
      
      private var _1791483012titleLabel:Label;
      
      private var _1856660101selectedSpell2:Image;
      
      private var _917721335alerter:IAlerterProvider;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":GradientCanvas,
               "stylesFactory":function():void
               {
                  this.borderColor = 3355443;
                  this.borderStyle = "inset";
                  this.borderThickness = 1;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "x":0,
                     "percentWidth":100,
                     "height":35,
                     "y":0,
                     "styleName":"chatBackground"
                  };
               }
            }),new UIComponentDescriptor({
               "type":VBox,
               "id":"spellBox",
               "stylesFactory":function():void
               {
                  this.verticalGap = 5;
                  this.paddingLeft = 10;
                  this.paddingRight = 10;
                  this.paddingBottom = 5;
                  this.paddingTop = 5;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":100,
                     "percentHeight":100,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":HBox,
                        "id":"selectionBox",
                        "stylesFactory":function():void
                        {
                           this.verticalAlign = "middle";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "percentHeight":100,
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"titleLabel",
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"spellSelectionText"};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Spacer,
                                 "propertiesFactory":function():Object
                                 {
                                    return {"percentWidth":100};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Button,
                                 "events":{"click":"___SpellSelectDialog_Button1_click"},
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "buttonMode":true,
                                       "styleName":"chooseGameExitButton"
                                    };
                                 }
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":TileList,
                        "id":"spellsList",
                        "events":{
                           "itemClick":"__spellsList_itemClick",
                           "itemRollOver":"__spellsList_itemRollOver",
                           "itemRollOut":"__spellsList_itemRollOut"
                        },
                        "stylesFactory":function():void
                        {
                           this.borderStyle = "none";
                           this.backgroundAlpha = 0;
                           this.verticalScrollBarStyleName = "chatScroll";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "columnCount":5,
                              "columnWidth":78,
                              "rowCount":3,
                              "itemRenderer":_SpellSelectDialog_ClassFactory1_c(),
                              "horizontalScrollPolicy":"off",
                              "selectable":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":HBox,
                        "stylesFactory":function():void
                        {
                           this.horizontalGap = 14;
                           this.paddingLeft = 4;
                           this.paddingBottom = 4;
                           this.paddingRight = 4;
                           this.verticalAlign = "middle";
                           this.horizontalAlign = "center";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Image,
                                 "id":"selectedSpell1",
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "height":42,
                                       "width":42,
                                       "visible":true
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Image,
                                 "id":"selectedSpell2",
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "height":42,
                                       "width":42,
                                       "visible":true
                                    };
                                 }
                              })]
                           };
                        }
                     })]
                  };
               }
            })]};
         }
      });
      
      public function SpellSelectDialog()
      {
         super();
         mx_internal::_document = this;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.styleName = "chatBackground";
         this.clipContent = false;
         this.addEventListener("keyDown",this.___SpellSelectDialog_Canvas1_keyDown);
         this.addEventListener("creationComplete",this.___SpellSelectDialog_Canvas1_creationComplete);
      }
      
      [Bindable(event="propertyChange")]
      public function get spellBox() : VBox
      {
         return this._2124508285spellBox;
      }
      
      public function set spellBox(param1:VBox) : void
      {
         var _loc2_:Object = this._2124508285spellBox;
         if(_loc2_ !== param1)
         {
            this._2124508285spellBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellBox",_loc2_,param1));
         }
      }
      
      public function set titleLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1791483012titleLabel;
         if(_loc2_ !== param1)
         {
            this._1791483012titleLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleLabel",_loc2_,param1));
         }
      }
      
      public function get spellIndex() : uint
      {
         return this._spellIndex;
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedSpell1() : Image
      {
         return this._1856660100selectedSpell1;
      }
      
      private function onSpellOut(param1:ListEvent) : void
      {
         var _loc2_:SpellSelectRendererAS = param1.itemRenderer as SpellSelectRendererAS;
         _loc2_.selectionText = "";
      }
      
      [Bindable(event="propertyChange")]
      public function get alerter() : IAlerterProvider
      {
         return this._917721335alerter;
      }
      
      private function escListenHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.closeSpellDialog();
         }
      }
      
      public function set selectedSpell1(param1:Image) : void
      {
         var _loc2_:Object = this._1856660100selectedSpell1;
         if(_loc2_ !== param1)
         {
            this._1856660100selectedSpell1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedSpell1",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      private function closeButtonClicked() : void
      {
         if(this.spell1)
         {
            this.confirmSpells(this.spell1,null);
         }
         this.closeSpellDialog();
      }
      
      public function ___SpellSelectDialog_Button1_click(param1:MouseEvent) : void
      {
         this.confirmSpells(this.spell1,this.spell2);
      }
      
      private function drawSpellSelectionBackground(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint, param6:uint) : void
      {
         this.graphics.beginFill(param5);
         this.graphics.lineStyle(1,param5);
         this.graphics.drawRect(param1,param2,param3,param4);
         this.graphics.endFill();
         this.graphics.lineStyle(1,param6);
         this.graphics.moveTo(param1,param2);
         this.graphics.lineTo(param1,param2 + param4);
         this.graphics.lineTo(param1 + param3,param2 + param4);
         this.graphics.lineTo(param1 + param3,param2);
      }
      
      public function set spellIndex(param1:uint) : void
      {
         if(this._spellIndex == param1)
         {
            return;
         }
         this._spellIndex = param1;
         this.spellIndexChanged = true;
         this.invalidateProperties();
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedSpell2() : Image
      {
         return this._1856660101selectedSpell2;
      }
      
      protected function setSpell1Image() : void
      {
         if(!this.selectedSpell1)
         {
            return;
         }
         if(this.spell1)
         {
            this.selectedSpell1.source = ImagePackLookup.instance.getSpellSource(this.spell1);
         }
         else
         {
            this.selectedSpell1.source = null;
         }
      }
      
      private function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc3_:Array = this.getStyle("fillColors");
         var _loc4_:Array = this.getStyle("fillAlphas");
         var _loc5_:Number = Number(this.getStyle("cornerRadius"));
         StyleManager.getColorNames(_loc3_);
         this.graphics.clear();
         var _loc6_:Number = this.getStyle("borderAlpha") == undefined ? 0 : Number(this.getStyle("borderAlpha"));
         var _loc7_:Number = this.getStyle("borderThickness") == undefined ? 1 : Number(this.getStyle("borderThickness"));
         if(_loc7_ > 0)
         {
            this.graphics.lineStyle(_loc7_,this.getStyle("borderColor"),_loc6_,true);
         }
         var _loc8_:Number = param1;
         var _loc9_:Number = this.spellBox.getStyle("paddingTop") + this.spellBox.getStyle("paddingBottom");
         var _loc10_:Number = 0;
         if(this.selectionBox)
         {
            _loc8_ = Math.max(this.selectionBox.getExplicitOrMeasuredWidth(),_loc8_);
            _loc9_ += this.selectionBox.getExplicitOrMeasuredHeight();
            _loc10_++;
         }
         if(this.spellsList)
         {
            _loc8_ = Math.max(this.spellsList.getExplicitOrMeasuredWidth(),_loc8_);
            _loc9_ += this.spellsList.getExplicitOrMeasuredHeight();
            _loc10_++;
         }
         _loc9_ += (_loc10_ - 1) * this.spellBox.getStyle("verticalGap");
         this.graphics.beginGradientFill(GradientType.LINEAR,_loc3_,_loc4_,null,this.verticalGradientMatrix(0,0,param1,param2));
         this.graphics.drawRect(0,0,_loc8_,_loc9_);
         this.graphics.endFill();
         if(Boolean(this.selectedSpell1) && Boolean(this.selectedSpell1.source != null) && this.selectedSpell1.source != "")
         {
            _loc11_ = _loc8_ / 2 - 7 - this.selectedSpell1.getExplicitOrMeasuredWidth() - 4;
            _loc12_ = _loc9_ + this.spellBox.getStyle("verticalGap") - 5;
            _loc13_ = this.selectedSpell1.getExplicitOrMeasuredWidth() + 8;
            _loc14_ = this.selectedSpell1.getExplicitOrMeasuredHeight() + 4;
            this.drawSpellSelectionBackground(_loc11_,_loc12_,_loc13_,_loc14_,_loc3_[1],16777215);
         }
         if(Boolean(this.selectedSpell1) && Boolean(this.selectedSpell2.source != null) && this.selectedSpell2.source != "")
         {
            _loc15_ = _loc8_ / 2 + 7 - 4;
            _loc16_ = _loc9_ + this.spellBox.getStyle("verticalGap") - 5;
            _loc17_ = this.selectedSpell2.getExplicitOrMeasuredWidth() + 8;
            _loc18_ = this.selectedSpell2.getExplicitOrMeasuredHeight() + 4;
            this.drawSpellSelectionBackground(_loc15_,_loc16_,_loc17_,_loc18_,_loc3_[1],16777215);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectionBox() : HBox
      {
         return this._1629054817selectionBox;
      }
      
      public function set spellsList(param1:TileList) : void
      {
         var _loc2_:Object = this._1498797175spellsList;
         if(_loc2_ !== param1)
         {
            this._1498797175spellsList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellsList",_loc2_,param1));
         }
      }
      
      private function confirmSpells(param1:Spell, param2:Spell) : void
      {
         dispatchEvent(new SpellSelectEvent(SpellSelectEvent.SPELLS_SELECTED,param1,param2));
         this.closeSpellDialog();
      }
      
      protected function setSpell2Image() : void
      {
         if(!this.selectedSpell2)
         {
            return;
         }
         if(this.spell2)
         {
            this.selectedSpell2.source = ImagePackLookup.instance.getSpellSource(this.spell2);
         }
         else
         {
            this.selectedSpell2.source = null;
         }
      }
      
      public function set alerter(param1:IAlerterProvider) : void
      {
         var _loc2_:Object = this._917721335alerter;
         if(_loc2_ !== param1)
         {
            this._917721335alerter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alerter",_loc2_,param1));
         }
      }
      
      public function get chooseBoth() : Boolean
      {
         return this._chooseBoth;
      }
      
      public function ___SpellSelectDialog_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function onCreationComplete() : void
      {
         this.spellIndexChanged = false;
         this.setTitleText();
         if(this.arrowedAlertViewManager)
         {
            this.arrowedAlertViewManager.modalParent = true;
            this.arrowedAlertViewManager.activate();
         }
         this.setTileListProvider();
         this.setSelectedSpells();
         if(this.spellIndex == 1 && !this.chooseBoth)
         {
            this.setSpell1Image();
         }
         else if(this.spellIndex == 2)
         {
            this.setSpell2Image();
         }
         this.spellProviderChanged = false;
      }
      
      public function get spellProvider() : ArrayCollection
      {
         return this._spellProvider;
      }
      
      public function __spellsList_itemRollOver(param1:ListEvent) : void
      {
         this.onSpellOver(param1);
      }
      
      public function set selectedSpell2(param1:Image) : void
      {
         var _loc2_:Object = this._1856660101selectedSpell2;
         if(_loc2_ !== param1)
         {
            this._1856660101selectedSpell2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedSpell2",_loc2_,param1));
         }
      }
      
      public function set selectionBox(param1:HBox) : void
      {
         var _loc2_:Object = this._1629054817selectionBox;
         if(_loc2_ !== param1)
         {
            this._1629054817selectionBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectionBox",_loc2_,param1));
         }
      }
      
      protected function setSelectedSpells() : void
      {
         var _loc1_:SpellSelection = null;
         if(!this.spellProvider)
         {
            this.spell1 = null;
            this.spell2 = null;
            return;
         }
         for each(_loc1_ in this.spellProvider)
         {
            if(_loc1_.selected)
            {
               if(_loc1_.selectedIndex == 1)
               {
                  this.spell1 = _loc1_.spell;
               }
               else
               {
                  this.spell2 = _loc1_.spell;
               }
               if(Boolean(this.spell1) && Boolean(this.spell2))
               {
                  break;
               }
            }
         }
      }
      
      public function ___SpellSelectDialog_Canvas1_keyDown(param1:KeyboardEvent) : void
      {
         this.escListenHandler(param1);
      }
      
      private function confirmSpell(param1:SpellSelectRendererAS) : void
      {
         dispatchEvent(new SpellSelectEvent(SpellSelectEvent.SPELLS_SELECTED,param1.spellSelection.spell,null));
         this.closeSpellDialog();
      }
      
      public function __spellsList_itemRollOut(param1:ListEvent) : void
      {
         this.onSpellOut(param1);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.spellIndexChanged && Boolean(this.titleLabel))
         {
            this.setTitleText();
            this.spellIndexChanged = false;
         }
         if(this.spellProviderChanged)
         {
            this.setTileListProvider();
            this.setSelectedSpells();
            if(this.spellIndex == 1 && !this.chooseBoth)
            {
               this.setSpell1Image();
            }
            else if(this.spellIndex == 2)
            {
               this.setSpell2Image();
            }
            this.spellProviderChanged = false;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get spellsList() : TileList
      {
         return this._1498797175spellsList;
      }
      
      private function onSpellClicked(param1:ListEvent) : void
      {
         var _loc2_:SpellSelectRendererAS = param1.itemRenderer as SpellSelectRendererAS;
         var _loc3_:SpellSelection = _loc2_.spellSelection;
         if(!_loc3_ || !_loc3_.available)
         {
            return;
         }
         if(this.chooseBoth && this.spellIndex == 1)
         {
            this.pendingSpell = _loc3_.spell;
            this.spell1 = _loc3_.spell;
            this.setSpell1Image();
            this.invalidateDisplayList();
            ++this.spellIndex;
            return;
         }
         if(Boolean(this.pendingSpell) && this.pendingSpell.spellId == _loc3_.spell.spellId)
         {
            return;
         }
         if(Boolean(_loc3_) && Boolean(_loc3_.available))
         {
            if(this.spellIndex == 2 && Boolean(this.pendingSpell))
            {
               this.confirmSpells(this.pendingSpell,_loc3_.spell);
               this.pendingSpell = null;
            }
            else if(this.spellIndex == 1)
            {
               this.confirmSpells(_loc3_.spell,null);
            }
            else
            {
               this.confirmSpells(null,_loc3_.spell);
            }
         }
      }
      
      public function __spellsList_itemClick(param1:ListEvent) : void
      {
         this.onSpellClicked(param1);
      }
      
      private function _SpellSelectDialog_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = SpellSelectRendererAS;
         return _loc1_;
      }
      
      protected function setTitleText() : void
      {
         var _loc1_:String = resourceManager.getString("resources","championSelection_spell_selection_title",[this.spellIndex]);
         if(_loc1_ == "" || _loc1_ == null)
         {
            _loc1_ = "**Choose Spell #" + this.spellIndex;
         }
         this.titleLabel.text = _loc1_;
      }
      
      public function set chooseBoth(param1:Boolean) : void
      {
         this._chooseBoth = param1;
      }
      
      public function set spellProvider(param1:ArrayCollection) : void
      {
         if(this._spellProvider == param1)
         {
            return;
         }
         this._spellProvider = param1;
         this.spellProviderChanged = true;
         this.invalidateProperties();
      }
      
      private function closeSpellDialog() : void
      {
         if(this.arrowedAlertViewManager)
         {
            this.arrowedAlertViewManager.deactivate();
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function cancel() : void
      {
         this.closeButtonClicked();
      }
      
      [Bindable(event="propertyChange")]
      public function get titleLabel() : Label
      {
         return this._1791483012titleLabel;
      }
      
      private function onSpellOver(param1:ListEvent) : void
      {
         var _loc2_:SpellSelectRendererAS = param1.itemRenderer as SpellSelectRendererAS;
         if(!_loc2_.selected)
         {
            _loc2_.selectionText = this.spellIndex.toString();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.drawBackground(param1,param2);
      }
      
      protected function setTileListProvider() : void
      {
         if(!this.spellsList)
         {
            return;
         }
         this.spellsList.dataProvider = this.spellProvider;
      }
   }
}

