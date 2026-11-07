package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.adobe.effects.SaturationFade;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.controllers.game.views.popup.SpellToolTip;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.model.SpellSelection;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.ToolTipEvent;
   
   public class SpellSelectRendererAS extends UIComponent implements IListItemRenderer
   {
      
      private static const BUTTON_STATE_UP:String = "up";
      
      private static const BUTTON_STATE_OVER:String = "over";
      
      protected static const GRAYSCALE_MATRIX:Array = [0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
      
      private var _showName:Boolean = true;
      
      protected var _data:Object;
      
      public var spellImage:Image;
      
      protected var selectedChanged:Boolean = false;
      
      protected var selectionTextChanged:Boolean = false;
      
      public var selectedLabel:Label;
      
      private var _spell:Spell;
      
      protected var availableChanged:Boolean = false;
      
      public var fadeIn:SaturationFade;
      
      private var _available:Boolean = true;
      
      public var spellSlot:cs_championItem;
      
      public var spellName:Label;
      
      public var fadeOut:SaturationFade;
      
      private var _selectionText:String = "1";
      
      private var _spellSelection:SpellSelection;
      
      public var glowFilter:GlowFilter;
      
      protected var spellChanged:Boolean = false;
      
      protected var showNameChanged:Boolean = false;
      
      private var _selected:Boolean = false;
      
      public function SpellSelectRendererAS()
      {
         super();
      }
      
      protected function createGlowFilter() : GlowFilter
      {
         var _loc1_:Number = Number(getStyle("glowAlpha"));
         if(isNaN(_loc1_))
         {
            _loc1_ = 1;
         }
         var _loc2_:Number = Number(getStyle("glowColor"));
         if(isNaN(_loc2_))
         {
            _loc2_ = 0;
         }
         var _loc3_:Number = Number(getStyle("glowBlurX"));
         if(isNaN(_loc3_))
         {
            _loc3_ = 12;
         }
         var _loc4_:Number = Number(getStyle("glowBlurY"));
         if(isNaN(_loc4_))
         {
            _loc4_ = 12;
         }
         return new GlowFilter(_loc2_,_loc1_,_loc3_,_loc4_);
      }
      
      protected function onMouseOver(param1:MouseEvent) : void
      {
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         if(Boolean(this.spellSlot) && Boolean(this.available) && Boolean(this.selectedLabel))
         {
            this.selectedLabel.visible = true;
            dispatchEvent(new ListEvent(ListEvent.ITEM_ROLL_OVER,true,true,-1,-1,"",this));
         }
      }
      
      private function setSelected() : void
      {
         if(this.selected)
         {
            if(this.spellSlot)
            {
               this.spellSlot.currentState = BUTTON_STATE_OVER;
            }
            if(this.selectedLabel)
            {
               this.selectedLabel.visible = true;
            }
            if(this.spellName)
            {
               this.spellName.setStyle("color","#E38914");
            }
         }
         else
         {
            if(this.spellSlot)
            {
               this.spellSlot.currentState = BUTTON_STATE_UP;
            }
            if(this.selectedLabel)
            {
               this.selectedLabel.visible = false;
            }
         }
      }
      
      public function set available(param1:Boolean) : void
      {
         if(this._available = param1)
         {
            return;
         }
         this._available = param1;
         this.availableChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("availableChanged"));
      }
      
      [Bindable(event="selectedChanged")]
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      protected function onToolTipCreate(param1:ToolTipEvent) : void
      {
         if(!this.spell)
         {
            return;
         }
         this.createSpellTooltip(param1);
      }
      
      [Bindable(event="showNameChanged")]
      public function get showName() : Boolean
      {
         return this._showName;
      }
      
      protected function setData() : void
      {
         if(this.spellSelection == this.data)
         {
            return;
         }
         this._spellSelection = this.data as SpellSelection;
         if(this._spellSelection)
         {
            if(this.spellSelection.spell != this.spell)
            {
               this._spell = this._spellSelection.spell;
               this.spellChanged = true;
               invalidateProperties();
               dispatchEvent(new Event("spellChanged"));
            }
            this.available = this.spellSelection.available;
         }
         dispatchEvent(new Event("spellSelectionChanged"));
      }
      
      [Bindable(event="spellChanged")]
      public function get spell() : Spell
      {
         return this._spell;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set selectionText(param1:String) : void
      {
         if(this._selectionText == param1)
         {
            return;
         }
         this._selectionText = param1;
         this.selectionTextChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("selectionTextChanged"));
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.spellSlot)
         {
            this.createSpellImage();
            this.createSpellSlot();
            addChild(this.spellImage);
            addChild(this.spellSlot);
         }
         if(!this.glowFilter)
         {
            this.glowFilter = this.createGlowFilter();
         }
         if(!this.selectedLabel)
         {
            this.createSelectedLabel();
         }
         if(!this.spellName)
         {
            this.createSpellName();
         }
         mouseChildren = false;
         buttonMode = true;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this.selectedChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("selectedChanged"));
      }
      
      protected function onCreationComplete(param1:FlexEvent) : void
      {
         this.removeEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
         if(this.selectedLabel)
         {
            this.selectedLabel.filters = [this.glowFilter];
            this.selectedLabel.text = this.selectionText;
         }
         if(this.spellName)
         {
            if(this.spell)
            {
               this.spellName.text = this.spell.displayName;
            }
            this.spellName.visible = this.showName;
         }
         if(Boolean(this.spellImage) && Boolean(this.spell))
         {
            this.spellImage.source = ImagePackLookup.instance.getSpellSource(this.spell);
         }
         this.spellChanged = false;
         this.selectionTextChanged = false;
         this.setSelected();
         this.selectedChanged = false;
         toolTip = "unused";
         if(this.spellSlot)
         {
            this.spellSlot.useHandCursor = this.available;
            this.spellSlot.mouseEnabled = this.available;
            this.spellSlot.buttonMode = this.available;
         }
         this.updateSaturationFilter();
         this.availableChanged = false;
         if(this.spellName)
         {
            this.spellName.visible = this.showName;
         }
         this.showNameChanged = false;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,this.createSpellTooltip);
      }
      
      private function createSpellImage() : void
      {
         this.spellImage = new Image();
         this.spellImage.scaleContent = true;
         this.spellImage.maintainAspectRatio = true;
      }
      
      private function createSpellSlot() : void
      {
         this.spellSlot = new cs_championItem();
         this.spellSlot.useHandCursor = true;
         this.spellSlot.mouseEnabled = true;
         this.spellSlot.buttonMode = true;
      }
      
      [Bindable(event="spellSelectionChanged")]
      public function get spellSelection() : SpellSelection
      {
         return this._spellSelection;
      }
      
      [Bindable(event="availableChanged")]
      public function get available() : Boolean
      {
         return this._available;
      }
      
      private function createSpellName() : void
      {
         this.spellName = new Label();
         this.spellName.visible = this.showName;
         this.spellName.setStyle("color","#ffffff");
         this.spellName.setStyle("textAlign","center");
         this.spellName.styleName = "s1FormLinkLabel";
         addChild(this.spellName);
      }
      
      public function set showName(param1:Boolean) : void
      {
         if(this._showName == param1)
         {
            return;
         }
         this._showName = param1;
         this.showNameChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("showNameChanged"));
      }
      
      private function createSpellTooltip(param1:ToolTipEvent) : void
      {
         var _loc2_:SpellToolTip = new SpellToolTip();
         _loc2_.data = this.spell;
         param1.toolTip = _loc2_;
      }
      
      [Bindable(event="selectionTextChanged")]
      public function get selectionText() : String
      {
         return this._selectionText;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         this.setData();
         dispatchEvent(new Event("dataChanged"));
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         if(this.spellSlot)
         {
            _loc1_ = Number(this.spellSlot.getExplicitOrMeasuredWidth());
            _loc2_ = Number(this.spellSlot.getExplicitOrMeasuredHeight());
         }
         if(this.showName && Boolean(this.spellName))
         {
            _loc2_ += this.spellName.getExplicitOrMeasuredHeight();
         }
         measuredWidth = measuredMinWidth = _loc1_;
         measuredHeight = measuredMinHeight = _loc2_;
      }
      
      protected function updateSaturationFilter() : void
      {
         var _loc1_:ColorMatrixFilter = null;
         if(!this.spellImage)
         {
            return;
         }
         if(this.available && this.spellImage.filters.length > 0)
         {
            this.spellImage.filters = [];
         }
         else if(!this.available && filters.length == 0)
         {
            _loc1_ = new ColorMatrixFilter();
            _loc1_.matrix = GRAYSCALE_MATRIX;
            this.spellImage.filters = [_loc1_];
         }
      }
      
      protected function onMouseOut(param1:MouseEvent) : void
      {
         if(Boolean(this.spellSlot) && !this.selected)
         {
            this.selectedLabel.visible = false;
            dispatchEvent(new ListEvent(ListEvent.ITEM_ROLL_OUT,true,true,-1,-1,"",this));
         }
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.spellChanged)
         {
            if(this.spellImage)
            {
               this.spellImage.source = ImagePackLookup.instance.getSpellSource(this.spell);
            }
            if(this.spellName)
            {
               this.spellName.text = this.spell.displayName;
            }
            invalidateDisplayList();
            this.spellChanged = false;
         }
         if(this.selectionTextChanged)
         {
            if(this.selectedLabel)
            {
               this.selectedLabel.text = this.selectionText;
               this.invalidateDisplayList();
            }
         }
         if(this.availableChanged)
         {
            this.updateSaturationFilter();
            if(this.spellSlot)
            {
               this.spellSlot.useHandCursor = this.available;
               this.spellSlot.mouseEnabled = this.available;
               this.spellSlot.buttonMode = this.available;
            }
            this.availableChanged = false;
            this.invalidateDisplayList();
         }
         if(this.selectedChanged)
         {
            this.setSelected();
            this.selectedChanged = false;
         }
         if(this.showNameChanged)
         {
            if(this.spellName)
            {
               this.spellName.visible = this.showName;
               this.invalidateSize();
               this.invalidateDisplayList();
            }
            this.showNameChanged = false;
         }
      }
      
      override protected function initializationComplete() : void
      {
         super.initializationComplete();
         this.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,this.onToolTipCreate);
         this.addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
      }
      
      private function createSelectedLabel() : void
      {
         this.selectedLabel = new Label();
         this.selectedLabel.styleName = "spellSelectSelectedLabel";
         this.selectedLabel.filters = [this.glowFilter];
         this.selectedLabel.visible = this.selected;
         this.selectedLabel.setStyle("textAlign","center");
         addChild(this.selectedLabel);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc5_:Number = 0;
         if(Boolean(this.spellName) && this.showName)
         {
            _loc5_ = Math.max(this.spellName.getExplicitOrMeasuredHeight(),0);
            this.spellName.setActualSize(param1 - 5,_loc5_);
            this.spellName.move(0,param2 - _loc5_);
         }
         if(this.spellSlot)
         {
            _loc3_ = _loc4_ = Math.min(param1,param2,this.spellSlot.getExplicitOrMeasuredWidth(),this.spellSlot.getExplicitOrMeasuredHeight());
            this.spellSlot.setActualSize(_loc3_,_loc4_);
            this.spellSlot.x = (param1 - _loc3_) / 2;
            this.spellSlot.y = param2 - _loc4_ - _loc5_;
         }
         if(this.spellImage)
         {
            _loc6_ = Math.max(0,_loc3_ - 8);
            _loc7_ = Math.max(0,_loc4_ - 8);
            this.spellImage.setActualSize(_loc6_,_loc7_);
            this.spellImage.move((param1 - _loc6_) / 2,param2 - _loc4_ - _loc5_ + 4);
         }
         if(this.selectedLabel)
         {
            _loc8_ = Math.min(this.selectedLabel.getExplicitOrMeasuredWidth(),param1);
            _loc9_ = Math.min(this.selectedLabel.getExplicitOrMeasuredHeight(),param2);
            this.selectedLabel.setActualSize(_loc8_,_loc8_);
            this.selectedLabel.move((param1 - _loc8_) / 2,(Math.min(param2,param1) - _loc4_) / 2);
         }
      }
   }
}

