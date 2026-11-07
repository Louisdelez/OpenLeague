package com.riotgames.platform.gameclient.domain.game
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import mx.collections.ArrayCollection;
   
   public class GameOptionsList extends ArrayCollection
   {
      
      private var _baseLocalKey:String = "";
      
      private var _internalName:String = "";
      
      private var _associatedGameProperties:Array = null;
      
      private var _displayTitle:String = "";
      
      private var _toolTip:String = "";
      
      private var _displayName:String = "";
      
      private var _selectedIndex:int = -1;
      
      public function GameOptionsList(param1:String, param2:String, param3:Array = null, param4:GameOptionsList = null, param5:Array = null)
      {
         super(param5);
         this._internalName = param1;
         this._baseLocalKey = param2;
         this._displayTitle = RiotResourceLoader.getString(param2 + "_title",param1);
         this._displayName = RiotResourceLoader.getString(param2 + "_name",param1);
         this._toolTip = RiotResourceLoader.getString(param2 + "_tooltip",null);
         this._associatedGameProperties = param3;
         this.filterFunction = filterDisabledChildren;
      }
      
      private static function filterDisabledChildren(param1:Object) : Boolean
      {
         var _loc2_:GamePropertiesListData = param1 as GamePropertiesListData;
         if(Boolean(_loc2_))
         {
            return _loc2_.enabled;
         }
         var _loc3_:GameOptionsList = param1 as GameOptionsList;
         if(Boolean(_loc3_))
         {
            return _loc3_.enabled;
         }
         return false;
      }
      
      public function selectChild(param1:GamePropertiesListData) : Boolean
      {
         var _loc2_:int = 0;
         if(this.contains(param1))
         {
            _loc2_ = int(this.getItemIndex(param1));
            if(_loc2_ != this.selectedIndex)
            {
               this.selectedIndex = _loc2_;
               return true;
            }
         }
         return false;
      }
      
      public function get selectedChild() : GamePropertiesListData
      {
         if(this.selectedIndex < 0 || this.selectedIndex >= this.length)
         {
            return null;
         }
         return this.getItemAt(this.selectedIndex) as GamePropertiesListData;
      }
      
      public function get tooltip() : String
      {
         return this._toolTip;
      }
      
      public function get associatedPropertyNames() : Array
      {
         return this._associatedGameProperties;
      }
      
      public function get enabled() : Boolean
      {
         var _loc2_:GamePropertiesListData = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.length)
         {
            _loc2_ = this.getItemAt(_loc1_) as GamePropertiesListData;
            if(Boolean(_loc2_))
            {
               if(_loc2_.enabled)
               {
                  return true;
               }
            }
            _loc1_++;
         }
         return false;
      }
      
      public function get aspirationalToolTip() : String
      {
         return RiotResourceLoader.getString(this._baseLocalKey + "_aspirational_tooltip",null,[this.queueLevelRequirement]);
      }
      
      public function get queueLevelRequirement() : int
      {
         var _loc3_:GamePropertiesListData = null;
         var _loc1_:int = LevelUpInfo.MAX_LEVEL;
         var _loc2_:int = 0;
         while(_loc2_ < this.length)
         {
            _loc3_ = this.getItemAt(_loc2_) as GamePropertiesListData;
            if(Boolean(_loc3_))
            {
               if(_loc3_.queueLevelRequirement > 0 && _loc3_.queueLevelRequirement < _loc1_)
               {
                  _loc1_ = _loc3_.queueLevelRequirement;
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function set displayName(param1:String) : void
      {
         this._displayName = param1;
      }
      
      override public function addItem(param1:Object) : void
      {
         if(param1 is GamePropertiesListData)
         {
            super.addItem(param1);
         }
      }
      
      public function addValue(param1:Object, param2:String, param3:String, param4:String) : GamePropertiesListData
      {
         var _loc6_:String = null;
         var _loc5_:GamePropertiesListData = new GamePropertiesListData();
         for each(_loc6_ in this._associatedGameProperties)
         {
            if(!param1.hasOwnProperty(_loc6_))
            {
               return null;
            }
            _loc5_.modifierProperties[_loc6_] = param1[_loc6_];
         }
         _loc5_.displayTitle = RiotResourceLoader.getString(param2 + "_title",param2 + "_title");
         _loc5_.subTitle = RiotResourceLoader.getString(param2 + "_subtitle","");
         _loc5_.baseLocaleKey = param2;
         _loc5_.internalName = param3;
         _loc5_.gameKey = param4;
         _loc5_.parentList = this;
         this.addItem(_loc5_);
         return _loc5_;
      }
      
      public function getNumberOfOptions() : uint
      {
         return this.length;
      }
      
      public function get isAspirational() : Boolean
      {
         var _loc3_:GamePropertiesListData = null;
         var _loc1_:Boolean = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.length)
         {
            _loc3_ = this.getItemAt(_loc2_) as GamePropertiesListData;
            if(Boolean(_loc3_))
            {
               if(!_loc3_.isAspirational)
               {
                  _loc1_ = false;
                  break;
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function addItemAt(param1:Object, param2:int) : void
      {
         if(param1 is GamePropertiesListData)
         {
            super.addItemAt(param1,param2);
         }
      }
      
      public function get internalName() : String
      {
         return this._internalName;
      }
      
      public function get displayName() : String
      {
         return this._displayName;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         this._selectedIndex = param1;
      }
      
      public function get displayTitle() : String
      {
         return this._displayTitle;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
   }
}

