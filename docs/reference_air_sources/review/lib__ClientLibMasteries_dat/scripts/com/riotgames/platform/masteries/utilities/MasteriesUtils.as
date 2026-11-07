package com.riotgames.platform.masteries.utilities
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.AbstractBook;
   import com.riotgames.platform.gameclient.masteries.Talent;
   import com.riotgames.platform.gameclient.masteries.TalentEntry;
   import com.riotgames.platform.gameclient.masteries.TalentGroup;
   import com.riotgames.platform.gameclient.masteries.TalentRow;
   import com.riotgames.platform.masteries.events.MasteryError;
   import com.riotgames.platform.masteries.objects.MasteryPage;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   
   public class MasteriesUtils
   {
      
      private static var masteriesByGameCode:Dictionary;
      
      private static var masteryRowMap:Dictionary;
      
      private static var masteryGroupMap:Dictionary;
      
      private static var masteryGroupMapByGroupId:Dictionary;
      
      private static var maxMasteryItems:Dictionary;
      
      private static var _registeredMasteryTree:ArrayCollection;
      
      public function MasteriesUtils()
      {
         super();
      }
      
      public static function getMasteriesList() : Dictionary
      {
         return masteriesByGameCode;
      }
      
      public static function getMasteryByID(param1:int) : Talent
      {
         if(Boolean(masteriesByGameCode))
         {
            return masteriesByGameCode[param1];
         }
         throw new MasteryError("Masteries tree has not been registered at the time of mastery lookup. This is bad.");
      }
      
      public static function getMasteryRowByMasteryID(param1:int) : TalentRow
      {
         if(Boolean(masteryRowMap))
         {
            return masteryRowMap[param1];
         }
         throw new MasteryError("Masteries tree has not been registered at the time of mastery row lookup. This is bad.");
      }
      
      public static function getMasteryGroupByMasteryID(param1:int) : TalentGroup
      {
         if(Boolean(masteryGroupMap))
         {
            return masteryGroupMap[param1];
         }
         throw new MasteryError("Masteries tree has not been registered at the time of mastery group lookup. This is bad.");
      }
      
      public static function getLocalizedGroupName(param1:int) : String
      {
         var _loc2_:TalentGroup = null;
         if(Boolean(masteryGroupMap))
         {
            for each(_loc2_ in masteryGroupMap)
            {
               if(Boolean(_loc2_) && _loc2_.tltGroupId == param1)
               {
                  return RiotResourceLoader.getString("masteries_tooltip_name_" + _loc2_.name);
               }
            }
            return "**badGroupId";
         }
         throw new MasteryError("Masteries tree has not been registered at the time of mastery group name lookup. This is bad.");
      }
      
      public static function getLocalizedPageName(param1:String, param2:int) : String
      {
         var _loc3_:String = "";
         var _loc4_:String = RiotResourceLoader.getString("masteries_page_defaultUserPageName","PAGE",[(param2 + 1).toString()]);
         if(param1.indexOf(AbstractBook.PAGE_NAME_TOKEN) >= 0)
         {
            _loc3_ = _loc4_;
         }
         else
         {
            _loc3_ = param1;
         }
         return _loc3_;
      }
      
      public static function getModuleLocalizedPageName(param1:String, param2:int) : String
      {
         var _loc3_:String = "";
         var _loc4_:String = ResourceManager.getInstance().getString("masteries_resources","masteries_page_defaultUserPageName",[(param2 + 1).toString()]);
         if(param1.indexOf(AbstractBook.PAGE_NAME_TOKEN) >= 0)
         {
            _loc3_ = _loc4_;
         }
         else
         {
            _loc3_ = param1;
         }
         return _loc3_;
      }
      
      public static function registerTree(param1:ArrayCollection) : void
      {
         var _loc2_:TalentGroup = null;
         var _loc3_:TalentRow = null;
         var _loc4_:Talent = null;
         _registeredMasteryTree = param1;
         if(Boolean(_registeredMasteryTree))
         {
            masteriesByGameCode = new Dictionary(true);
            masteryRowMap = new Dictionary(true);
            masteryGroupMap = new Dictionary(true);
            masteryGroupMapByGroupId = new Dictionary(true);
            maxMasteryItems = new Dictionary(true);
            for each(_loc2_ in _registeredMasteryTree)
            {
               for each(_loc3_ in _loc2_.talentRows)
               {
                  for each(_loc4_ in _loc3_.talents)
                  {
                     masteriesByGameCode[_loc4_.tltId] = _loc4_;
                     masteryRowMap[_loc4_.tltId] = _loc3_;
                     masteryGroupMap[_loc4_.tltId] = _loc2_;
                     masteryGroupMapByGroupId[_loc2_.tltGroupId] = _loc2_;
                     if(_loc3_.tltRowId % _loc2_.talentRows.length == 0)
                     {
                        maxMasteryItems[_loc4_.tltId] = _loc4_;
                     }
                  }
               }
            }
         }
         else
         {
            masteriesByGameCode = null;
            masteryRowMap = null;
            masteryGroupMap = null;
         }
      }
      
      public static function getSpentPointsInGroup(param1:MasteryPage, param2:int) : int
      {
         var _loc5_:TalentEntry = null;
         var _loc6_:Talent = null;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return 0;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param1.getNumberOfEntries())
         {
            _loc5_ = param1.getEntryByIndex(_loc4_) as TalentEntry;
            _loc6_ = masteriesByGameCode[_loc5_.talentId];
            if(_loc5_ != null && _loc6_ != null && _loc6_.talentGroupId == param2)
            {
               _loc3_ += _loc5_.rank;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getTotalPointsUpToRow(param1:TalentGroup, param2:int, param3:MasteryPage) : int
      {
         var _loc5_:uint = 0;
         var _loc6_:TalentRow = null;
         var _loc7_:uint = 0;
         var _loc8_:Talent = null;
         var _loc4_:int = 0;
         if(param1 != null && param2 >= 0 && param3 != null)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.talentRows.length)
            {
               _loc6_ = param1.talentRows.getItemAt(_loc5_) as TalentRow;
               _loc7_ = 0;
               while(_loc7_ < _loc6_.talents.length)
               {
                  _loc8_ = _loc6_.talents.getItemAt(_loc7_) as Talent;
                  if(_loc8_.talentRowId <= param2)
                  {
                     _loc4_ += param3.getRankOfMastery(_loc8_.tltId);
                  }
                  _loc7_++;
               }
               _loc5_++;
            }
         }
         else
         {
            _loc4_ = -1;
         }
         return _loc4_;
      }
      
      public static function getDeepestRowWithPoints(param1:int, param2:MasteryPage) : int
      {
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < masteryGroupMapByGroupId[param1].talentRows.length)
         {
            _loc6_ = getTotalPointsUpToRow(masteryGroupMapByGroupId[param1],_loc5_ + 1 + (param1 - 1) * 6,param2);
            if(_loc6_ > _loc4_)
            {
               _loc4_ = _loc6_;
               _loc3_ = _loc5_ + 1;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public static function getIfIsUltimateTalentForGroup(param1:int, param2:int) : Boolean
      {
         return maxMasteryItems[param1] != null && (maxMasteryItems[param1] as Talent).talentGroupId == param2;
      }
      
      public static function getIfUltimateMasteryPurchased(param1:int, param2:MasteryPage) : Boolean
      {
         var _loc5_:TalentEntry = null;
         var _loc6_:Talent = null;
         var _loc3_:Boolean = false;
         if(param2 == null)
         {
            return false;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param2.getNumberOfEntries())
         {
            _loc5_ = param2.getEntryByIndex(_loc4_) as TalentEntry;
            _loc6_ = masteriesByGameCode[_loc5_.talentId];
            if(_loc6_.talentGroupId == param1 && maxMasteryItems[_loc5_.talentId] != null)
            {
               _loc3_ = _loc5_.rank == _loc6_.maxRank;
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function buildFakeMasteryTree() : ArrayCollection
      {
         var _loc2_:TalentGroup = null;
         var _loc3_:TalentRow = null;
         var _loc4_:Talent = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         _loc2_ = new TalentGroup();
         _loc2_.talentRows = new ArrayCollection();
         _loc2_.tltGroupId = 3;
         _loc2_.name = "Utility";
         _loc2_.index = 2;
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 13;
         _loc3_.tltGroupId = 3;
         _loc3_.pointsToActivate = 0;
         _loc3_.index = 0;
         _loc4_ = new Talent();
         _loc4_.tltId = 712;
         _loc4_.gameCode = 712;
         _loc4_.name = "Wanderer";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 13;
         _loc4_.index = 1;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 714;
         _loc4_.gameCode = 714;
         _loc4_.name = "Improved Recall";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 13;
         _loc4_.index = 3;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 713;
         _loc4_.gameCode = 713;
         _loc4_.name = "Meditation";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 13;
         _loc4_.index = 2;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 711;
         _loc4_.gameCode = 711;
         _loc4_.name = "Summoner\'s Insight";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 13;
         _loc4_.index = 0;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 14;
         _loc3_.tltGroupId = 3;
         _loc3_.pointsToActivate = 4;
         _loc3_.index = 1;
         _loc4_ = new Talent();
         _loc4_.tltId = 722;
         _loc4_.gameCode = 722;
         _loc4_.name = "Mastermind";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 14;
         _loc4_.index = 1;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 721;
         _loc4_.gameCode = 721;
         _loc4_.name = "Scout";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 14;
         _loc4_.index = 0;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 724;
         _loc4_.gameCode = 724;
         _loc4_.name = "Artificer";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 14;
         _loc4_.index = 3;
         _loc4_.maxRank = 2;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 723;
         _loc4_.gameCode = 723;
         _loc4_.name = "Expanded Mind";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 14;
         _loc4_.index = 2;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 15;
         _loc3_.tltGroupId = 3;
         _loc3_.pointsToActivate = 8;
         _loc3_.index = 2;
         _loc4_ = new Talent();
         _loc4_.tltId = 733;
         _loc4_.gameCode = 733;
         _loc4_.name = "Vampirism";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 15;
         _loc4_.index = 2;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 732;
         _loc4_.gameCode = 732;
         _loc4_.name = "Runic Affinity";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 15;
         _loc4_.index = 1;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 731;
         _loc4_.gameCode = 731;
         _loc4_.name = "Greed";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 15;
         _loc4_.index = 0;
         _loc4_.maxRank = 4;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 734;
         _loc4_.gameCode = 734;
         _loc4_.name = "Biscuiteer";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 15;
         _loc4_.index = 3;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 16;
         _loc3_.tltGroupId = 3;
         _loc3_.pointsToActivate = 12;
         _loc3_.index = 3;
         _loc4_ = new Talent();
         _loc4_.tltId = 742;
         _loc4_.gameCode = 742;
         _loc4_.name = "Awareness";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 16;
         _loc4_.index = 1;
         _loc4_.maxRank = 4;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 741;
         _loc4_.gameCode = 741;
         _loc4_.name = "Wealth";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 16;
         _loc4_.index = 0;
         _loc4_.maxRank = 2;
         _loc4_.prereqTalentGameCode = 731;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 744;
         _loc4_.gameCode = 744;
         _loc4_.name = "Explorer";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 16;
         _loc4_.index = 3;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 734;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 743;
         _loc4_.gameCode = 743;
         _loc4_.name = "Strength of Spirit";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 16;
         _loc4_.index = 2;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 17;
         _loc3_.tltGroupId = 3;
         _loc3_.pointsToActivate = 16;
         _loc3_.index = 4;
         _loc4_ = new Talent();
         _loc4_.tltId = 752;
         _loc4_.gameCode = 752;
         _loc4_.name = "Intelligence";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 17;
         _loc4_.index = 1;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 751;
         _loc4_.gameCode = 751;
         _loc4_.name = "Pickpocket";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 17;
         _loc4_.index = 0;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 18;
         _loc3_.tltGroupId = 3;
         _loc3_.pointsToActivate = 20;
         _loc3_.index = 5;
         _loc4_ = new Talent();
         _loc4_.tltId = 762;
         _loc4_.gameCode = 762;
         _loc4_.name = "Nimble";
         _loc4_.talentGroupId = 3;
         _loc4_.talentRowId = 18;
         _loc4_.index = 1;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc1_.addItem(_loc2_);
         _loc2_ = new TalentGroup();
         _loc2_.talentRows = new ArrayCollection();
         _loc2_.tltGroupId = 1;
         _loc2_.name = "Offense";
         _loc2_.index = 0;
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 1;
         _loc3_.tltGroupId = 1;
         _loc3_.pointsToActivate = 0;
         _loc3_.index = 0;
         _loc4_ = new Talent();
         _loc4_.tltId = 514;
         _loc4_.gameCode = 514;
         _loc4_.name = "Butcher";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 1;
         _loc4_.index = 3;
         _loc4_.maxRank = 2;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 512;
         _loc4_.gameCode = 512;
         _loc4_.name = "Fury";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 1;
         _loc4_.index = 1;
         _loc4_.maxRank = 4;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 511;
         _loc4_.gameCode = 511;
         _loc4_.name = "Summoner\'s Wrath";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 1;
         _loc4_.index = 0;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 513;
         _loc4_.gameCode = 513;
         _loc4_.name = "Sorcery";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 1;
         _loc4_.index = 2;
         _loc4_.maxRank = 4;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 2;
         _loc3_.tltGroupId = 1;
         _loc3_.pointsToActivate = 4;
         _loc3_.index = 1;
         _loc4_ = new Talent();
         _loc4_.tltId = 524;
         _loc4_.gameCode = 524;
         _loc4_.name = "Destruction";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 2;
         _loc4_.index = 3;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 523;
         _loc4_.gameCode = 523;
         _loc4_.name = "Blast";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 2;
         _loc4_.index = 2;
         _loc4_.maxRank = 4;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 522;
         _loc4_.gameCode = 522;
         _loc4_.name = "Deadliness";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 2;
         _loc4_.index = 1;
         _loc4_.maxRank = 4;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 3;
         _loc3_.tltGroupId = 1;
         _loc3_.pointsToActivate = 8;
         _loc3_.index = 2;
         _loc4_ = new Talent();
         _loc4_.tltId = 532;
         _loc4_.gameCode = 532;
         _loc4_.name = "Weapon Expertise";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 3;
         _loc4_.index = 1;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 522;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 531;
         _loc4_.gameCode = 531;
         _loc4_.name = "Havoc";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 3;
         _loc4_.index = 0;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 533;
         _loc4_.gameCode = 533;
         _loc4_.name = "Arcane Knowledge";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 3;
         _loc4_.index = 2;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 523;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 4;
         _loc3_.tltGroupId = 1;
         _loc3_.pointsToActivate = 12;
         _loc3_.index = 3;
         _loc4_ = new Talent();
         _loc4_.tltId = 544;
         _loc4_.gameCode = 544;
         _loc4_.name = "Spellsword";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 4;
         _loc4_.index = 3;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 543;
         _loc4_.gameCode = 543;
         _loc4_.name = "Mental Force";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 4;
         _loc4_.index = 2;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 542;
         _loc4_.gameCode = 542;
         _loc4_.name = "Brute Force";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 4;
         _loc4_.index = 1;
         _loc4_.maxRank = 2;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 541;
         _loc4_.gameCode = 541;
         _loc4_.name = "Lethality";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 4;
         _loc4_.index = 0;
         _loc4_.maxRank = 2;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 5;
         _loc3_.tltGroupId = 1;
         _loc3_.pointsToActivate = 16;
         _loc3_.index = 4;
         _loc4_ = new Talent();
         _loc4_.tltId = 551;
         _loc4_.gameCode = 551;
         _loc4_.name = "Frenzy";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 5;
         _loc4_.index = 0;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 541;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 553;
         _loc4_.gameCode = 553;
         _loc4_.name = "Archmage";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 5;
         _loc4_.index = 2;
         _loc4_.maxRank = 4;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 552;
         _loc4_.gameCode = 552;
         _loc4_.name = "Sunder";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 5;
         _loc4_.index = 1;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 6;
         _loc3_.tltGroupId = 1;
         _loc3_.pointsToActivate = 20;
         _loc3_.index = 5;
         _loc4_ = new Talent();
         _loc4_.tltId = 562;
         _loc4_.gameCode = 562;
         _loc4_.name = "Executioner";
         _loc4_.talentGroupId = 1;
         _loc4_.talentRowId = 6;
         _loc4_.index = 1;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc1_.addItem(_loc2_);
         _loc2_ = new TalentGroup();
         _loc2_.talentRows = new ArrayCollection();
         _loc2_.tltGroupId = 2;
         _loc2_.name = "Defense";
         _loc2_.index = 1;
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 7;
         _loc3_.tltGroupId = 2;
         _loc3_.pointsToActivate = 0;
         _loc3_.index = 0;
         _loc4_ = new Talent();
         _loc4_.tltId = 614;
         _loc4_.gameCode = 614;
         _loc4_.name = "Tough Skin";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 7;
         _loc4_.index = 3;
         _loc4_.maxRank = 2;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 611;
         _loc4_.gameCode = 611;
         _loc4_.name = "Summoner\'s Resolve";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 7;
         _loc4_.index = 0;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 612;
         _loc4_.gameCode = 612;
         _loc4_.name = "Perseverance";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 7;
         _loc4_.index = 1;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 613;
         _loc4_.gameCode = 613;
         _loc4_.name = "Durability";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 7;
         _loc4_.index = 2;
         _loc4_.maxRank = 4;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 8;
         _loc3_.tltGroupId = 2;
         _loc3_.pointsToActivate = 4;
         _loc3_.index = 1;
         _loc4_ = new Talent();
         _loc4_.tltId = 622;
         _loc4_.gameCode = 622;
         _loc4_.name = "Resistance";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 8;
         _loc4_.index = 1;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 624;
         _loc4_.gameCode = 624;
         _loc4_.name = "Bladed Armor";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 8;
         _loc4_.index = 3;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 614;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 621;
         _loc4_.gameCode = 621;
         _loc4_.name = "Hardiness";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 8;
         _loc4_.index = 0;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 9;
         _loc3_.tltGroupId = 2;
         _loc3_.pointsToActivate = 8;
         _loc3_.index = 2;
         _loc4_ = new Talent();
         _loc4_.tltId = 634;
         _loc4_.gameCode = 634;
         _loc4_.name = "Safeguard";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 9;
         _loc4_.index = 3;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 632;
         _loc4_.gameCode = 632;
         _loc4_.name = "Relentless";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 9;
         _loc4_.index = 1;
         _loc4_.maxRank = 2;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 631;
         _loc4_.gameCode = 631;
         _loc4_.name = "Unyielding";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 9;
         _loc4_.index = 0;
         _loc4_.maxRank = 2;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 633;
         _loc4_.gameCode = 633;
         _loc4_.name = "Veteran\'s Scars";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 9;
         _loc4_.index = 2;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 613;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 10;
         _loc3_.tltGroupId = 2;
         _loc3_.pointsToActivate = 12;
         _loc3_.index = 3;
         _loc4_ = new Talent();
         _loc4_.tltId = 641;
         _loc4_.gameCode = 641;
         _loc4_.name = "Block";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 10;
         _loc4_.index = 0;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 631;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 642;
         _loc4_.gameCode = 642;
         _loc4_.name = "Tenacious";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 10;
         _loc4_.index = 1;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 643;
         _loc4_.gameCode = 643;
         _loc4_.name = "Juggernaut";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 10;
         _loc4_.index = 2;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 11;
         _loc3_.tltGroupId = 2;
         _loc3_.pointsToActivate = 16;
         _loc3_.index = 4;
         _loc4_ = new Talent();
         _loc4_.tltId = 654;
         _loc4_.gameCode = 654;
         _loc4_.name = "Reinforced Armor";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 11;
         _loc4_.index = 3;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 651;
         _loc4_.gameCode = 651;
         _loc4_.name = "Defender";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 11;
         _loc4_.index = 0;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 652;
         _loc4_.gameCode = 652;
         _loc4_.name = "Legendary Armor";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 11;
         _loc4_.index = 1;
         _loc4_.maxRank = 3;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc4_ = new Talent();
         _loc4_.tltId = 653;
         _loc4_.gameCode = 653;
         _loc4_.name = "Good Hands";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 11;
         _loc4_.index = 2;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc3_ = new TalentRow();
         _loc3_.talents = new ArrayCollection();
         _loc3_.tltRowId = 12;
         _loc3_.tltGroupId = 2;
         _loc3_.pointsToActivate = 20;
         _loc3_.index = 5;
         _loc4_ = new Talent();
         _loc4_.tltId = 662;
         _loc4_.gameCode = 662;
         _loc4_.name = "Honor Guard";
         _loc4_.talentGroupId = 2;
         _loc4_.talentRowId = 12;
         _loc4_.index = 1;
         _loc4_.maxRank = 1;
         _loc4_.prereqTalentGameCode = 0;
         _loc4_.minLevel = 1;
         _loc4_.minTier = 1;
         _loc3_.talents.addItem(_loc4_);
         _loc2_.talentRows.addItem(_loc3_);
         _loc1_.addItem(_loc2_);
         return _loc1_;
      }
   }
}

