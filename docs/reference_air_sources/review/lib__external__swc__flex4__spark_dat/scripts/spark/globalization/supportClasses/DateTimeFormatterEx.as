package spark.globalization.supportClasses
{
   import mx.utils.ObjectUtil;
   import mx.utils.StringUtil;
   import spark.formatters.DateTimeFormatter;
   
   [ExcludeClass]
   [ResourceBundle("core")]
   public class DateTimeFormatterEx extends DateTimeFormatter
   {
      
      public static const DATESTYLE_yMMM:String = "yMMM";
      
      public static const DATESTYLE_yMMMM:String = "yMMMM";
      
      public static const DATESTYLE_MMMEEEd:String = "MMMEEEd";
      
      public static const MAX_YEAR:uint = 30827;
      
      public static const MIN_YEAR:uint = 1601;
      
      private static const MILLISECONDS_PER_DAY:int = 1000 * 60 * 60 * 24;
      
      private static const REGEXP_YEAR:RegExp = /(^(?:[^'y]*(?:'[^']*')*[^y']*)*)(y+('年'|年|'년'|년)?)/;
      
      private static const REGEXP_MONTH:RegExp = /(^(?:[^'LM]*(?:'[^']*')*[^LM']*)*)([LM]+('月'|月|'월'|월)?)/;
      
      private static const REGEXP_DAYOFMONTH:RegExp = /(^(?:[^'d]*(?:'[^']*')*[^d']*)*)(d+('日'|日|'일'|일)?)/;
      
      private static const REGEXP_HOUR:RegExp = /(^(?:[^'hH]*(?:'[^']*')*[^hH']*)*)([hH]+('時'|時|'时'|时|'시'|시)?)/;
      
      private static const REGEXP_MINUTE:RegExp = /(^(?:[^'m]*(?:'[^']*')*[^m']*)*)(m+('分'|分|'분'|분)?)/;
      
      private static const REGEXP_SECOND:RegExp = /(^(?:[^'s]*(?:'[^']*')*[^s']*)*)(s+('秒'|秒|'초'|초)?)/;
      
      private static const REGEXP_AMPM:RegExp = /^(.*)(a)(?:[^']*'[^']*')*[^']*$/;
      
      private static const REGEXP_DAYOFWEEK:RegExp = /(^(?:[^'E]*(?:'[^']*')*[^E']*)*)(E+)/;
      
      private static const REGEXP_LOCALEID:RegExp = /([a-z]+)?(?:[-_]([A-Z][a-z]+))?(?:[-_]([A-Z]+))?([a-zA-Z-]+)?(?:@(.*))?/;
      
      private static const REGEXP_L:RegExp = /(?:^[^'L]*(?:'[^']*')*[^L']*)(L+)/;
      
      private static const REGEXP_c:RegExp = /(?:^[^'c]*(?:'[^']*')*[^c']*)(c+)/;
      
      private static const FORMATPATTERNLIST_yMMM:Vector.<FormatPattern> = new <FormatPattern>[new FormatPattern("LLL y",["ca","cs","el","fi","ru","sk","uk"]),new FormatPattern("LLL y.",["hr"]),new FormatPattern("MM/y",["pt_PT"]),new FormatPattern("MMM \'de\' y",["pt","seh"]),new FormatPattern("MMM \'di\' y",["kea"]),new FormatPattern("MMM y",["af","agq","am","ar","asa","bas","be","bem","bez","bm","bn","cgg","chr","cy","da","dav","de","dje","dua","dyo","ebu","ee","en","es","et","eu","ewo","fa","ff","fr","fur","gl","gsw","gu","guz","ha","he","hi","id","ig","is","it","jmc","kab","kam","kde","khq","ki","kln","kn","ksb","ksf","lag","lg","ln","lu","luo","luy","mas","mer","mfe","mg","mgh","mr","ms","mua","naq","nb","nd","nl","nmg","nn","nus","nyn","pl","rm","rn","ro","rof","rwk","saq","sbp","ses","sg","shi","shi_Tfng","sl","sn","so","sq","sv","sw","swc","ta","te","teo","th","to","tr","twq","tzm","vai_Latn","vi","vun","wae","xog","yav","yo","zu"]),new FormatPattern("MMM y \'г\'",["bg"]),new FormatPattern("MMM y."
      ,["bs"]),new FormatPattern("MMM yyyy",["ak","brx","vai"]),new FormatPattern("MMM, y",["az","az_Cyrl"]),new FormatPattern("MMM. y",["sr"]),new FormatPattern("MMMی y",["ku"]),new FormatPattern("y MMM",["fil","ksh","mk","ml","my","root","sr_Latn","trv"]),new FormatPattern("y. MMM",["hu"]),new FormatPattern("yyyy. \'g\'. MMM",["lv"]),new FormatPattern("y년 MMM",["ko"]),new FormatPattern("y年M月",["ja","zh","zh_Hant"])];
      
      private static const FORMATPATTERNLIST_yMMMM:Vector.<FormatPattern> = new <FormatPattern>[new FormatPattern("LLLL \'dal\' y",["fur"]),new FormatPattern("LLLL \'de\' y",["ca"]),new FormatPattern("LLLL y",["pl","sk","uk"]),new FormatPattern("LLLL y.",["hr"]),new FormatPattern("MMMM \'de\' y",["es","seh"]),new FormatPattern("MMMM \'di\' y",["kea"]),new FormatPattern("MMMM y",["af","am","ar","asa","be","bem","bez","bm","bn","cgg","chr","dav","ebu","ee","fa","ff","gl","gsw","guz","ha","he","ig","is","jmc","kab","kam","kde","khq","ki","kln","ksb","ksh","lag","lg","luo","luy","mas","mer","mfe","mg","naq","nd","nyn","rm","ro","rof","rwk","saq","ses","sg","shi","shi_Tfng","sn","so","sq","sw","teo","th","to","tr","tzm","vi","vun","xog","yo"]),new FormatPattern("MMMM yyyy",["ak","brx","vai"]),new FormatPattern("y MMMM",["fil","mk","ml","my","sr","sr_Latn","trv"]),new FormatPattern("y. \'g\'. MMMM",["lv"])];
      
      private static const FORMATPATTERNLIST_yMMMM_extra:Vector.<FormatPattern> = new <FormatPattern>[new FormatPattern("MMMM y",["agq","az","az_Cyrl","bas","cy","da","de","dje","dua","dyo","en","et","eu","ewo","fr","gu","hi","id","it","kn","ksf","ku","ln","lu","mgh","mr","ms","mua","nb","nl","nmg","nn","nus","rn","sbp","sv","swc","ta","te","twq","vai_Latn","wae","yav","zu"]),new FormatPattern("y MMMM",["root"]),new FormatPattern("MMMM y \'г\'.",["bg"]),new FormatPattern("y. MMMM",["hu"]),new FormatPattern("y年M月",["ja","zh","zh_Hant"]),new FormatPattern("y년 MMMM",["ko"]),new FormatPattern("MMMM \'de\' y",["pt"]),new FormatPattern("MM/y",["pt_PT"]),new FormatPattern("LLLL y",["cs","el","fi","ru"])];
      
      private static const FORMATPATTERNLIST_MMMEEEd:Vector.<FormatPattern> = new <FormatPattern>[new FormatPattern("EEE, d MMM",["ro"]),new FormatPattern("ccc, d MMM",["ru"]),new FormatPattern("d MMM, E",["bg"]),new FormatPattern("d MMMM E",["tr"]),new FormatPattern("E d LLL",["fa"]),new FormatPattern("E d MMM",["agq","ar","bas","bm","bn","ca","dje","dua","dyo","en_GB","en_IN","es","ewo","ff","fr","fur","gl","id","kab","khq","ksf","ln","lu","mfe","mg","mua","nl","nmg","nus","rn","ses","sg","shi","shi_Tfng","sq","sv","swc","th","to","twq","vi","yav"]),new FormatPattern("E d. MMM",["da","fi","gsw","is","nb","nn","rm","sr","sr_Latn"]),new FormatPattern("E dd MMM",["en_ZA","en_ZW"]),new FormatPattern("E MMM d",["fil","mk","trv"]),new FormatPattern("E, d MMM",["be","el","en_AU","en_CA","en_HK","en_MT","en_NZ","en_SG","gu","hi","kn","mr","pl","ro","ta","te","uk"]),new FormatPattern("E, d בMMM",["he"]),new FormatPattern("E, d. MMM",["cs","de","et","hr","lv","sk","sl","wae"]),new FormatPattern("E, d/MM"
      ,["pt_PT"]),new FormatPattern("E, dd. MMM",["bs"]),new FormatPattern("E, MMM d",["af","ak","am","asa","bem","bez","brx","cgg","dav","ebu","ee","en","es_US","eu","guz","ha","ig","jmc","kam","kde","ki","kln","ksb","lag","lg","luo","luy","mas","mer","mgh","naq","nd","nyn","rof","rwk","saq","sbp","sn","so","sw","teo","tzm","vai","vai_Latn","vun","xog","yo","zu"]),new FormatPattern("E، dی MMM",["ku"]),new FormatPattern("EEE d MMM",["en_BE","it"]),new FormatPattern("EEE dd MMM",["en_BW","en_BZ"]),new FormatPattern("EEE, d \'de\' MMM",["pt"]),new FormatPattern("EEE, d MMM",["cy","kea","ms","seh"]),new FormatPattern("EEE, d, MMM",["az","az_Cyrl"]),new FormatPattern("EEE, MMM d",["my"]),new FormatPattern("MMM d E",["si"]),new FormatPattern("MMM d, E",["lt","ml"]),new FormatPattern("MMM d., E",["hu"]),new FormatPattern("MMM d일 (E)",["ko"]),new FormatPattern("M月d日(E)",["ja"]),new FormatPattern("M月d日E",["zh","zh_Hant"])];
      
      private static const FORMATPATTERNLIST_MMMEEEd_extra:Vector.<FormatPattern> = new <FormatPattern>[new FormatPattern("E MMM d",["root"]),new FormatPattern("EEE MMM d",["chr"]),new FormatPattern("EEE, MMM d",["ksh"])];
      
      private var _dateTimeSkeletonPattern:String;
      
      private var _elementPatternList:Object;
      
      public function DateTimeFormatterEx()
      {
         super();
      }
      
      private static function analysePattern(pattern:String, analyseDateElements:Boolean, analyseTimeElements:Boolean) : Object
      {
         var element:Object = null;
         var name:String = null;
         var elementList:Array = new Array();
         if(analyseDateElements)
         {
            DateTimeFormatterEx.extractDateElements(pattern,elementList);
         }
         if(analyseTimeElements)
         {
            DateTimeFormatterEx.extractTimeElements(pattern,elementList);
         }
         elementList.sortOn("index",Array.NUMERIC);
         var processedElementList:Object = new Object();
         for(var i:int = 0; i < elementList.length; i++)
         {
            element = new Object();
            element["index"] = i;
            element["pattern"] = elementList[i]["pattern"];
            name = elementList[i]["name"];
            processedElementList[name] = element;
         }
         return processedElementList;
      }
      
      private static function extractDateElements(pattern:String, elementList:Array) : void
      {
         var regExpOut:Object = null;
         var element:Object = null;
         for(var i:int = 0; i < 4; i++)
         {
            element = null;
            switch(i)
            {
               case 0:
                  regExpOut = REGEXP_YEAR.exec(pattern);
                  if(Boolean(regExpOut))
                  {
                     element = {
                        "name":"year",
                        "pattern":regExpOut[2],
                        "index":(regExpOut["index"] as int) + (regExpOut[1] as String).length
                     };
                  }
                  break;
               case 1:
                  regExpOut = REGEXP_MONTH.exec(pattern);
                  if(Boolean(regExpOut))
                  {
                     element = {
                        "name":"month",
                        "pattern":regExpOut[2],
                        "index":(regExpOut["index"] as int) + (regExpOut[1] as String).length
                     };
                  }
                  break;
               case 2:
                  regExpOut = REGEXP_DAYOFMONTH.exec(pattern);
                  if(Boolean(regExpOut))
                  {
                     element = {
                        "name":"dayOfMonth",
                        "pattern":regExpOut[2],
                        "index":(regExpOut["index"] as int) + (regExpOut[1] as String).length
                     };
                  }
                  break;
               case 3:
                  regExpOut = REGEXP_DAYOFWEEK.exec(pattern);
                  if(Boolean(regExpOut))
                  {
                     element = {
                        "name":"dayOfWeek",
                        "pattern":regExpOut[2],
                        "index":(regExpOut["index"] as int) + (regExpOut[1] as String).length
                     };
                  }
            }
            if(Boolean(element))
            {
               elementList.push(element);
            }
         }
      }
      
      private static function extractTimeElements(pattern:String, elementList:Array) : void
      {
         var regExpOut:Object = null;
         var element:Object = null;
         for(var i:int = 0; i < 4; i++)
         {
            element = null;
            switch(i)
            {
               case 0:
                  regExpOut = REGEXP_HOUR.exec(pattern);
                  if(Boolean(regExpOut))
                  {
                     element = {
                        "name":"hour",
                        "pattern":regExpOut[2],
                        "index":(regExpOut["index"] as int) + (regExpOut[1] as String).length
                     };
                  }
                  break;
               case 1:
                  regExpOut = REGEXP_MINUTE.exec(pattern);
                  if(Boolean(regExpOut))
                  {
                     element = {
                        "name":"minute",
                        "pattern":regExpOut[2],
                        "index":(regExpOut["index"] as int) + (regExpOut[1] as String).length
                     };
                  }
                  break;
               case 2:
                  regExpOut = REGEXP_SECOND.exec(pattern);
                  if(Boolean(regExpOut))
                  {
                     element = {
                        "name":"second",
                        "pattern":regExpOut[2],
                        "index":(regExpOut["index"] as int) + (regExpOut[1] as String).length
                     };
                  }
                  break;
               case 3:
                  regExpOut = REGEXP_AMPM.exec(pattern);
                  if(Boolean(regExpOut))
                  {
                     element = {
                        "name":"ampm",
                        "pattern":regExpOut[2],
                        "index":(regExpOut["index"] as int) + (regExpOut[1] as String).length
                     };
                  }
            }
            if(Boolean(element))
            {
               elementList.push(element);
            }
         }
      }
      
      override public function set dateStyle(value:String) : void
      {
         if(value == dateStyle)
         {
            return;
         }
         this.invalidateSkeletonPattern();
         this.invalidatePatternAnalysis();
         if(super.dateStyle == "custom")
         {
            super.dateStyle = value == "none" ? "long" : "none";
         }
         super.dateStyle = value;
      }
      
      override public function set dateTimePattern(value:String) : void
      {
         if(value == dateTimePattern)
         {
            return;
         }
         this.invalidateSkeletonPattern();
         this.invalidatePatternAnalysis();
         super.dateTimePattern = value;
      }
      
      override public function set timeStyle(value:String) : void
      {
         if(value == timeStyle)
         {
            return;
         }
         this.invalidateSkeletonPattern();
         this.invalidatePatternAnalysis();
         if(super.timeStyle == "custom")
         {
            super.timeStyle = value == "none" ? "long" : "none";
         }
         super.timeStyle = value;
      }
      
      [Bindable("change")]
      public function get dateTimeSkeletonPattern() : String
      {
         return this._dateTimeSkeletonPattern;
      }
      
      public function set dateTimeSkeletonPattern(value:String) : void
      {
         if(value == this._dateTimeSkeletonPattern)
         {
            return;
         }
         this._dateTimeSkeletonPattern = value;
         this.updatePattern();
         this.invalidatePatternAnalysis();
         update();
      }
      
      override public function setStyle(styleProp:String, newValue:*) : void
      {
         var oldValue:* = super.getStyle(styleProp);
         super.setStyle(styleProp,newValue);
         if(styleProp != "locale" || newValue == oldValue)
         {
            return;
         }
         this.updatePattern();
         this.invalidatePatternAnalysis();
         update();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         this.updatePattern();
         this.invalidatePatternAnalysis();
         update();
      }
      
      [Bindable("change")]
      public function getAmPmPattern() : String
      {
         var element:Object = this.elementPatternList["ampm"];
         return Boolean(element) ? element["pattern"] : null;
      }
      
      [Bindable("change")]
      public function getAmPmPosition() : int
      {
         var element:Object = this.elementPatternList["ampm"];
         return Boolean(element) ? int(element["index"]) : -1;
      }
      
      [Bindable("change")]
      public function getDayOfMonthPattern() : String
      {
         var element:Object = this.elementPatternList["dayOfMonth"];
         return Boolean(element) ? element["pattern"] : null;
      }
      
      [Bindable("change")]
      public function getDayOfMonthPosition() : int
      {
         var element:Object = this.elementPatternList["dayOfMonth"];
         return Boolean(element) ? int(element["index"]) : -1;
      }
      
      [Bindable("change")]
      public function getDayOfWeekPattern() : String
      {
         var element:Object = this.elementPatternList["dayOfWeek"];
         return Boolean(element) ? element["pattern"] : null;
      }
      
      [Bindable("change")]
      public function getDayOfWeekPosition() : int
      {
         var element:Object = this.elementPatternList["dayOfWeek"];
         return Boolean(element) ? int(element["index"]) : -1;
      }
      
      [Bindable("change")]
      public function getHourPattern() : String
      {
         var element:Object = this.elementPatternList["hour"];
         return Boolean(element) ? element["pattern"] : null;
      }
      
      [Bindable("change")]
      public function getHourPosition() : int
      {
         var element:Object = this.elementPatternList["hour"];
         return Boolean(element) ? int(element["index"]) : -1;
      }
      
      [Bindable("change")]
      public function getMinutePattern() : String
      {
         var element:Object = this.elementPatternList["minute"];
         return Boolean(element) ? element["pattern"] : null;
      }
      
      [Bindable("change")]
      public function getMinutePosition() : int
      {
         var element:Object = this.elementPatternList["minute"];
         return Boolean(element) ? int(element["index"]) : -1;
      }
      
      [Bindable("change")]
      public function getMonthPattern() : String
      {
         var element:Object = this.elementPatternList["month"];
         return Boolean(element) ? element["pattern"] : null;
      }
      
      [Bindable("change")]
      public function getMonthPosition() : int
      {
         var element:Object = this.elementPatternList["month"];
         return Boolean(element) ? int(element["index"]) : -1;
      }
      
      [Bindable("change")]
      public function getSecondPattern() : String
      {
         var element:Object = this.elementPatternList["second"];
         return Boolean(element) ? element["pattern"] : null;
      }
      
      [Bindable("change")]
      public function getSecondPosition() : int
      {
         var element:Object = this.elementPatternList["second"];
         return Boolean(element) ? int(element["index"]) : -1;
      }
      
      [Bindable("change")]
      public function getUse24HourFlag() : Object
      {
         var hourPattern:String = this.getHourPattern();
         if(!hourPattern)
         {
            return null;
         }
         var use24Hour:Boolean = hourPattern.indexOf("H") >= 0;
         var use12Hour:Boolean = hourPattern.indexOf("h") >= 0;
         if(use24Hour && !use12Hour)
         {
            return true;
         }
         if(!use24Hour && use12Hour)
         {
            return false;
         }
         return null;
      }
      
      [Bindable("change")]
      public function getYearPattern() : String
      {
         var element:Object = this.elementPatternList["year"];
         return Boolean(element) ? element["pattern"] : null;
      }
      
      [Bindable("change")]
      public function getYearPosition() : int
      {
         var element:Object = this.elementPatternList["year"];
         return Boolean(element) ? int(element["index"]) : -1;
      }
      
      private function get elementPatternList() : Object
      {
         if(!this._elementPatternList)
         {
            this._elementPatternList = DateTimeFormatterEx.analysePattern(dateTimePattern,this.patternMayContainDateElements,this.patternMayContainTimeElements);
            this.addPrefixes(dateTimePattern,this._elementPatternList);
         }
         return this._elementPatternList;
      }
      
      private function set elementPatternList(value:Object) : void
      {
         if(Boolean(value))
         {
            throw new ArgumentError("Invalid assignment.");
         }
         this._elementPatternList = null;
      }
      
      private function get patternMayContainDateElements() : Boolean
      {
         switch(super.dateStyle)
         {
            case "none":
               return false;
            case "custom":
               switch(this._dateTimeSkeletonPattern)
               {
                  case DATESTYLE_yMMM:
                  case DATESTYLE_yMMMM:
                  case DATESTYLE_MMMEEEd:
                     return true;
                  default:
                     return true;
               }
               break;
            default:
               return true;
         }
      }
      
      private function get patternMayContainTimeElements() : Boolean
      {
         switch(super.timeStyle)
         {
            case "none":
               return false;
            case "custom":
               switch(this._dateTimeSkeletonPattern)
               {
                  case DATESTYLE_yMMM:
                  case DATESTYLE_yMMMM:
                  case DATESTYLE_MMMEEEd:
                     return false;
                  default:
                     return true;
               }
               break;
            default:
               return true;
         }
      }
      
      private function addPrefixes(dateTimePattern:String, elementPatternList:Object) : void
      {
         var locale:String = getStyle("locale");
         if(!locale || !elementPatternList)
         {
            return;
         }
         var language:String = locale.substr(0,2);
         if(language == "vi" && dateTimePattern.indexOf("năm") != -1)
         {
            if(Boolean(elementPatternList["year"]))
            {
               elementPatternList["year"]["pattern"] = "\'năm\' " + elementPatternList["year"]["pattern"];
            }
            if(Boolean(elementPatternList["month"]))
            {
               elementPatternList["month"]["pattern"] = "\'tháng\' " + elementPatternList["month"]["pattern"];
            }
            if(Boolean(elementPatternList["dayOfMonth"]))
            {
               elementPatternList["dayOfMonth"]["pattern"] = "\'Ngày\' " + elementPatternList["dayOfMonth"]["pattern"];
            }
         }
      }
      
      private function findBestMatchingPattern(locale:String, style:String) : String
      {
         var pattern:String = null;
         switch(style)
         {
            case DATESTYLE_yMMM:
               pattern = this.findBestMatchingPatternFromFormatPatternList(locale,FORMATPATTERNLIST_yMMM);
               break;
            case DATESTYLE_yMMMM:
               pattern = this.findBestMatchingPatternFromFormatPatternList(locale,FORMATPATTERNLIST_yMMMM);
               if(!pattern)
               {
                  pattern = this.findBestMatchingPatternFromFormatPatternList(locale,FORMATPATTERNLIST_yMMMM_extra);
               }
               break;
            case DATESTYLE_MMMEEEd:
               pattern = this.findBestMatchingPatternFromFormatPatternList(locale,FORMATPATTERNLIST_MMMEEEd);
               if(!pattern)
               {
                  pattern = this.findBestMatchingPatternFromFormatPatternList(locale,FORMATPATTERNLIST_MMMEEEd_extra);
               }
         }
         if(Boolean(pattern))
         {
            pattern = pattern.replace(REGEXP_L,function(matchedSubstring:String, capturedMatch1:String, index:int, str:String):String
            {
               return replaceString(matchedSubstring,capturedMatch1,index,str,"M");
            });
            pattern = pattern.replace(REGEXP_c,function(matchedSubstring:String, capturedMatch1:String, index:int, str:String):String
            {
               return replaceString(matchedSubstring,capturedMatch1,index,str,"E");
            });
         }
         return pattern;
      }
      
      private function findBestMatchingPatternFromFormatPatternList(findLocale:String, formatPatternList:Vector.<FormatPattern>) : String
      {
         var parsedLocale:Object = null;
         var score:uint = 0;
         var formatPattern:FormatPattern = null;
         var qNameList:Array = null;
         var qName:QName = null;
         var listedLocale:Object = null;
         if(!findLocale)
         {
            findLocale = "root";
         }
         parsedLocale = this.parseLocale(findLocale);
         var locale:String = parsedLocale["locale"];
         var language:String = parsedLocale["language"];
         var script:String = parsedLocale["script"];
         var region:String = parsedLocale["region"];
         var scoreList:Array = new Array();
         for each(formatPattern in formatPatternList)
         {
            qNameList = ObjectUtil.getClassInfo(formatPattern.locales)["properties"];
            for each(qName in qNameList)
            {
               score = 0;
               listedLocale = this.parseLocale(qName.localName);
               if(language == listedLocale["language"])
               {
                  score += 64;
                  if(script == listedLocale["script"])
                  {
                     score += 16;
                  }
                  else if(!script || !listedLocale["script"])
                  {
                     score += 8;
                  }
                  if(region == listedLocale["region"])
                  {
                     score += 4;
                  }
                  else if(!region || !listedLocale["region"])
                  {
                     score += 2;
                  }
               }
               if(locale != "root" && listedLocale["locale"] == "root")
               {
                  score++;
               }
               if(Boolean(score))
               {
                  scoreList.push({
                     "locale":qName.localName,
                     "pattern":formatPattern.pattern,
                     "score":score
                  });
               }
            }
         }
         if(!scoreList.length)
         {
            return null;
         }
         scoreList.sortOn("score",Array.NUMERIC | Array.DESCENDING);
         return scoreList[0]["pattern"];
      }
      
      private function invalidatePatternAnalysis() : void
      {
         this.elementPatternList = null;
      }
      
      private function invalidateSkeletonPattern() : void
      {
         this._dateTimeSkeletonPattern = null;
      }
      
      private function parseLocale(locale:String) : Object
      {
         var regExpResult:Object = null;
         if(!locale)
         {
            return {
               "locale":"",
               "language":"",
               "script":"",
               "region":""
            };
         }
         regExpResult = REGEXP_LOCALEID.exec(locale);
         var language:String = Boolean(regExpResult[1]) ? regExpResult[1] : "";
         var script:String = Boolean(regExpResult[2]) ? regExpResult[2] : "";
         var region:String = Boolean(regExpResult[3]) ? regExpResult[3] : "";
         var normalizedLocale:String = locale.replace("-","_");
         return {
            "locale":normalizedLocale,
            "language":language,
            "script":script,
            "region":region
         };
      }
      
      private function replaceString(matchedSubstring:String, capturedMatch1:String, index:int, str:String, newChar:String) : String
      {
         var len:int = 0;
         var s:String = null;
         len = capturedMatch1.length;
         s = StringUtil.repeat(newChar,len);
         return matchedSubstring.substr(0,matchedSubstring.length - len) + s;
      }
      
      private function updatePattern() : void
      {
         if(!this._dateTimeSkeletonPattern)
         {
            return;
         }
         super.dateTimePattern = this.findBestMatchingPattern(actualLocaleIDName,this._dateTimeSkeletonPattern);
      }
   }
}

