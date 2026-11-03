package com.riotgames.platform.gameclient.domain
{
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.spellbook.SpellBookPageDTO")]
   public class SpellBookPageDTO extends AbstractBookPage
   {
      
      public function SpellBookPageDTO()
      {
         super();
      }
      
      private static function sumItemEffects(param1:Array) : Number
      {
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += param1[_loc3_];
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function removeSlot(param1:RuneSlot) : void
      {
         var _loc2_:SlotEntry = null;
         var _loc3_:int = 0;
         if(entries != null)
         {
            for each(_loc2_ in entries)
            {
               if(Boolean(_loc2_.getRuneSlot()) && _loc2_.getRuneSlot().id == param1.id)
               {
                  _loc3_ = int(entries.getItemIndex(_loc2_));
                  if(_loc3_ > -1)
                  {
                     entries.removeItemAt(_loc3_);
                  }
               }
            }
         }
      }
      
      public function deleteRuneBySlotNumber(param1:Number) : void
      {
         var _loc2_:SlotEntry = null;
         var _loc3_:int = 0;
         if(this.entries != null)
         {
            _loc3_ = 0;
            while(_loc3_ < entries.length)
            {
               _loc2_ = entries[_loc3_] as SlotEntry;
               if(Boolean(_loc2_.getRuneSlot()) && _loc2_.getRuneSlot().id == param1)
               {
                  entries.removeItemAt(_loc3_);
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      public function getCombinedStats() : ArrayCollection
      {
         var _loc4_:SlotEntry = null;
         var _loc5_:String = null;
         var _loc6_:Rune = null;
         var _loc7_:int = 0;
         var _loc8_:ItemEffect = null;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         var _loc11_:ItemEffect = null;
         var _loc12_:String = null;
         var _loc13_:Number = NaN;
         var _loc1_:ArrayCollection = new ArrayCollection();
         var _loc2_:Object = {};
         var _loc3_:Object = {};
         for each(_loc4_ in entries)
         {
            if(_loc4_.getRune() != null)
            {
               _loc6_ = _loc4_.getRune();
               if(_loc6_ != null && _loc6_.itemEffects != null && _loc6_.itemEffects.length > 0)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_.itemEffects.length)
                  {
                     _loc8_ = _loc6_.itemEffects[_loc7_];
                     if(_loc8_.name != null && _loc8_.value != 0)
                     {
                        _loc9_ = _loc8_.value;
                        _loc10_ = _loc8_.displayName;
                        if(_loc2_[_loc10_] != null)
                        {
                           _loc2_[_loc10_].push(_loc9_);
                        }
                        else
                        {
                           _loc2_[_loc10_] = [_loc9_];
                        }
                        _loc3_[_loc10_] = _loc8_.name;
                     }
                     _loc7_++;
                  }
               }
            }
         }
         for(_loc5_ in _loc2_)
         {
            _loc11_ = new ItemEffect();
            _loc12_ = _loc5_;
            _loc13_ = sumItemEffects(_loc2_[_loc5_]);
            _loc11_.value = _loc13_;
            _loc11_.displayName = _loc12_;
            _loc11_.name = _loc3_[_loc5_];
            _loc1_.addItem(_loc11_);
         }
         return _loc1_;
      }
      
      public function clearAllRunes() : void
      {
         this.entries.removeAll();
      }
      
      [Bindable(event="propertyChange")]
      public function set slotEntries(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.slotEntries;
         if(_loc2_ !== param1)
         {
            this._1372035250slotEntries = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"slotEntries",_loc2_,param1));
         }
      }
      
      public function toString() : String
      {
         return pageId + ": " + name;
      }
      
      public function getSpecificRuneCount(param1:Rune) : int
      {
         var _loc3_:SlotEntry = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this.entries)
         {
            if(Boolean(_loc3_.getRune()) && _loc3_.getRune().itemId == param1.itemId)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function getRuneBySlotNumber(param1:int) : Rune
      {
         var _loc3_:SlotEntry = null;
         var _loc4_:Rune = null;
         var _loc2_:ArrayCollection = entries;
         if(_loc2_ != null)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = _loc3_.getRune();
               if(Boolean(_loc3_ != null) && Boolean(_loc3_.getRuneSlot()) && _loc3_.getRuneSlot().id == param1)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
      
      public function get slotEntries() : ArrayCollection
      {
         return entries;
      }
      
      public function get displayName() : String
      {
         return this.name;
      }
      
      private function set _1372035250slotEntries(param1:ArrayCollection) : void
      {
         this.entries = param1;
      }
      
      public function containsRune(param1:Rune) : Boolean
      {
         var _loc3_:SlotEntry = null;
         var _loc2_:Boolean = false;
         for each(_loc3_ in this.entries)
         {
            if(Boolean(_loc3_.getRune()) && _loc3_.getRune().itemId == param1.itemId)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
      
      public function setRuneBySlotNumber(param1:RuneSlot, param2:Rune) : void
      {
         var _loc4_:SlotEntry = null;
         var _loc3_:Boolean = false;
         if(param2 == null)
         {
            this.removeSlot(param1);
            return;
         }
         if(entries != null)
         {
            for each(_loc4_ in entries)
            {
               if(Boolean(_loc4_.getRuneSlot()) && _loc4_.getRuneSlot().id == param1.id)
               {
                  _loc4_.setRune(param2);
                  _loc4_.setRuneSlot(param1);
                  _loc3_ = true;
                  break;
               }
            }
         }
         else
         {
            entries = new ArrayCollection();
         }
         if(_loc3_ == false)
         {
            _loc4_ = new SlotEntry();
            _loc4_.setRune(param2);
            _loc4_.setRuneSlot(param1);
            entries.addItem(_loc4_);
         }
      }
   }
}

