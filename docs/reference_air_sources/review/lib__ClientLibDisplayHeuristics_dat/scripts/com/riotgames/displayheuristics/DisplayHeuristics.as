package com.riotgames.displayheuristics
{
   import blix.util.math.mean;
   import blix.util.math.standardDeviation;
   
   public class DisplayHeuristics
   {
      
      public function DisplayHeuristics()
      {
         super();
      }
      
      public static function findTargets(param1:PathInfo, param2:Vector.<PathInfo>, param3:Number = 0.9) : Vector.<PathInfoResult>
      {
         var confidenceMean:Number;
         var confidenceStdDev:Number;
         var highestConfidence:Number;
         var results:Vector.<PathInfoResult>;
         var i:uint = 0;
         var exactPath:PathInfo = null;
         var matchWeight:MatchWeight = null;
         var confidence:Number = NaN;
         var newConfidence:Number = NaN;
         var normalizedConfidence:Number = NaN;
         var loosePath:PathInfo = param1;
         var allPaths:Vector.<PathInfo> = param2;
         var precision:Number = param3;
         var allPathsL:uint = allPaths.length;
         var paths:Vector.<PathInfo> = new Vector.<PathInfo>();
         var confidences:Array = new Array();
         var index:uint = 0;
         i = 0;
         while(i < allPathsL)
         {
            exactPath = allPaths[i];
            matchWeight = comparePaths(loosePath,exactPath);
            confidence = matchWeight.getConfidence();
            if(confidence > 0)
            {
               confidences[index] = confidence;
               paths[index] = exactPath;
               index++;
            }
            i++;
         }
         confidenceMean = Number(mean(confidences));
         confidenceStdDev = Number(standardDeviation(confidences));
         highestConfidence = 0;
         i = 0;
         while(i < index)
         {
            newConfidence = confidences[i] / (confidenceMean + confidenceStdDev);
            confidences[i] = newConfidence;
            if(newConfidence > highestConfidence)
            {
               highestConfidence = newConfidence;
            }
            i++;
         }
         results = new Vector.<PathInfoResult>();
         i = 0;
         while(i < index)
         {
            normalizedConfidence = confidences[i] / highestConfidence;
            if(normalizedConfidence >= precision)
            {
               results[results.length] = new PathInfoResult(paths[i].path,normalizedConfidence);
            }
            i++;
         }
         results = results.sort(function(param1:PathInfoResult, param2:PathInfoResult):Number
         {
            if(param1.confidence == param2.confidence)
            {
               return 0;
            }
            if(param1.confidence > param2.confidence)
            {
               return -1;
            }
            return 1;
         });
         return results;
      }
      
      public static function comparePaths(param1:PathInfo, param2:PathInfo) : MatchWeight
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc16_:Vector.<String> = null;
         var _loc17_:Boolean = false;
         var _loc18_:Vector.<String> = null;
         var _loc19_:MatchWeight = null;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc3_:MatchWeight = new MatchWeight();
         var _loc4_:uint = param2.pathSegments.length;
         var _loc5_:uint = param1.pathSegments.length;
         if(_loc5_ > _loc4_)
         {
            return new MatchWeight();
         }
         var _loc6_:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(_loc5_,true);
         var _loc9_:int = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_[_loc7_] = new Vector.<Number>(_loc4_,true);
            _loc16_ = param1.pathSegments[_loc7_];
            _loc17_ = false;
            _loc8_ = _loc9_;
            while(_loc8_ < _loc4_)
            {
               _loc18_ = param2.pathSegments[_loc8_];
               _loc19_ = comparePathSegments(_loc16_,_loc18_);
               _loc20_ = _loc19_.getConfidence();
               if(!_loc17_ && _loc20_ > 0)
               {
                  _loc9_ = _loc8_;
                  _loc17_ = true;
               }
               _loc6_[_loc7_][_loc8_] = _loc20_;
               _loc8_++;
            }
            if(!_loc17_)
            {
               return new MatchWeight();
            }
            _loc7_++;
         }
         var _loc10_:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(_loc5_,true);
         var _loc11_:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(_loc5_,true);
         var _loc14_:int = 0;
         _loc7_ = _loc5_ - 1;
         while(_loc7_ >= 0)
         {
            _loc10_[_loc7_] = new Vector.<Number>(_loc4_,true);
            _loc11_[_loc7_] = new Vector.<int>(_loc4_,true);
            _loc12_ = 0;
            _loc13_ = -1;
            _loc8_ = _loc4_ - _loc14_ - 1;
            while(_loc8_ >= _loc7_)
            {
               _loc21_ = 0;
               _loc22_ = _loc6_[_loc7_][_loc8_];
               if(_loc14_ > 0)
               {
                  _loc21_ = _loc10_[_loc7_ + 1][_loc8_ + 1];
                  if(_loc21_ == 0)
                  {
                     _loc22_ = 0;
                  }
                  else
                  {
                     _loc22_ += _loc21_;
                  }
               }
               if(_loc22_ > _loc12_)
               {
                  _loc12_ = _loc22_;
                  _loc13_ = _loc8_;
               }
               _loc10_[_loc7_][_loc8_] = _loc12_;
               _loc11_[_loc7_][_loc8_] = _loc13_;
               _loc8_--;
            }
            _loc14_++;
            _loc7_--;
         }
         var _loc15_:int = -1;
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc13_ = _loc11_[_loc7_][_loc15_ + 1];
            _loc23_ = _loc6_[_loc7_][_loc13_];
            _loc3_.mismatchScore += (_loc13_ - _loc15_ + 1) * DisplayHeuristicsConfig.MISSING_SEGMENT_SCORE;
            _loc3_.matchScore += _loc23_ * DisplayHeuristicsConfig.MATCHING_SEGMENT_SCORE;
            _loc3_.mismatchScore += (1 - _loc23_) * DisplayHeuristicsConfig.MATCHING_SEGMENT_SCORE;
            _loc15_ = _loc13_;
            _loc7_++;
         }
         _loc3_.mismatchScore += (_loc4_ - _loc15_ - 1) * DisplayHeuristicsConfig.MISSING_SEGMENT_AFTER_LAST_LOOSE_SCORE;
         return _loc3_;
      }
      
      private static function comparePathSegments(param1:Vector.<String>, param2:Vector.<String>) : MatchWeight
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc3_:MatchWeight = new MatchWeight();
         param2 = param2.slice();
         var _loc4_:int = 0;
         for each(_loc5_ in param1)
         {
            _loc7_ = calculateWordWeight(_loc5_);
            _loc8_ = param2.indexOf(_loc5_);
            if(_loc8_ == -1)
            {
               _loc3_.mismatchScore += _loc7_ * DisplayHeuristicsConfig.WORD_NOT_FOUND_SCORE;
            }
            else
            {
               if(_loc8_ == _loc4_)
               {
                  _loc9_ = DisplayHeuristicsConfig.WORD_EXACT_POSITION;
               }
               else if(_loc8_ < _loc4_)
               {
                  _loc9_ = DisplayHeuristicsConfig.WORD_PAST_POSITION;
               }
               else if(_loc8_ > _loc4_)
               {
                  _loc9_ = DisplayHeuristicsConfig.WORD_FUTURE_POSITION;
               }
               _loc10_ = _loc7_ * DisplayHeuristicsConfig.WORD_FOUND_SCORE;
               _loc3_.matchScore += _loc9_ * _loc10_;
               _loc3_.mismatchScore += (1 - _loc9_) * _loc10_;
               param2.splice(_loc8_,1);
               _loc4_ = _loc8_;
            }
         }
         for each(_loc6_ in param2)
         {
            _loc3_.mismatchScore += calculateWordWeight(_loc6_) * DisplayHeuristicsConfig.MISSING_WORD_SCORE;
         }
         return _loc3_;
      }
      
      private static function calculateWordWeight(param1:String) : Number
      {
         var _loc2_:uint = uint(param1.length);
         if(_loc2_ >= DisplayHeuristicsConfig.LONG_SEGMENT_LENGTH)
         {
            return DisplayHeuristicsConfig.LONG_SEGMENT_WEIGHT;
         }
         if(_loc2_ >= DisplayHeuristicsConfig.MEDIUM_SEGMENT_LENGTH)
         {
            return DisplayHeuristicsConfig.MEDIUM_SEGMENT_WEIGHT;
         }
         if(_loc2_ >= DisplayHeuristicsConfig.SHORT_SEGMENT_LENGTH)
         {
            return DisplayHeuristicsConfig.SHORT_SEGMENT_WEIGHT;
         }
         if(_loc2_ >= DisplayHeuristicsConfig.TRIVIAL_SEGMENT_LENGTH)
         {
            return DisplayHeuristicsConfig.TRIVIAL_SEGMENT_WEIGHT;
         }
         return 0;
      }
   }
}

