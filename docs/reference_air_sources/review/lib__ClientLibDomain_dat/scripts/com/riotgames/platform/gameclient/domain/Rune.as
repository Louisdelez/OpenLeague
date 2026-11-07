package com.riotgames.platform.gameclient.domain
{
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.catalog.runes.Rune")]
   public class Rune extends BaseItem
   {
      
      public static const DATA_FORMAT:String = "Rune";
      
      private var _878289888imagePath:String;
      
      private var _820735380runeType:RuneType;
      
      public function Rune(param1:Object = null)
      {
         var rune:Object = param1;
         super();
         baseType = "RUNE";
         if(rune != null)
         {
            try
            {
               this.itemId = rune.itemId;
               this.runeType = new RuneType();
               this.runeType.runeTypeId = rune.runeTypeId;
               this.tier = rune.tier;
               this.imagePath = rune.imagePath;
               if(rune.itemEffects is Array)
               {
                  this.itemEffects = new ArrayCollection(rune.itemEffects);
               }
            }
            catch(e:Error)
            {
               this.itemId = this.tier = 0;
               this.runeType = this.itemEffects = this.imagePath = null;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get imagePath() : String
      {
         return this._878289888imagePath;
      }
      
      [Bindable(event="propertyChange")]
      public function get runeType() : RuneType
      {
         return this._820735380runeType;
      }
      
      public function set imagePath(param1:String) : void
      {
         var _loc2_:Object = this._878289888imagePath;
         if(_loc2_ !== param1)
         {
            this._878289888imagePath = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imagePath",_loc2_,param1));
         }
      }
      
      public function set runeType(param1:RuneType) : void
      {
         var _loc2_:Object = this._820735380runeType;
         if(_loc2_ !== param1)
         {
            this._820735380runeType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeType",_loc2_,param1));
         }
      }
   }
}

