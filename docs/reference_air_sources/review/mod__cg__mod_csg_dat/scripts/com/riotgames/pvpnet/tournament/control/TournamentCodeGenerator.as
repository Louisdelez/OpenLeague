package com.riotgames.pvpnet.tournament.control
{
   import com.riotgames.platform.gameclient.domain.game.AllowSpectators;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameConfig;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.tournament.model.CustomGameModuleConfig;
   import com.riotgames.util.Base64Url;
   import com.riotgames.util.json.jsonDecode;
   import com.riotgames.util.json.jsonEncode;
   
   public class TournamentCodeGenerator
   {
      
      private var config:CustomGameModuleConfig;
      
      public function TournamentCodeGenerator(param1:CustomGameModuleConfig)
      {
         super();
         this.config = param1;
      }
      
      private function getPathValue(param1:Array, param2:int, param3:int, param4:String) : String
      {
         var _loc6_:String = null;
         var _loc5_:int = param2;
         while(_loc5_ <= param3 && _loc5_ < param1.length)
         {
            _loc6_ = param1[_loc5_];
            if(_loc6_.substr(0,param4.length) == param4)
            {
               return _loc6_.substr(param4.length);
            }
            _loc5_++;
         }
         return null;
      }
      
      public function parseJoinOrCreateUrl(param1:String) : PracticeGameConfig
      {
         var game:PracticeGameConfig;
         var lastSegmentIndex:int;
         var firstSegmentIndex:int;
         var variant:GameFlowVariant = null;
         var pickString:String = null;
         var numPlayers:int = 0;
         var json:String = null;
         var dynamicParams:Object = null;
         var url:String = param1;
         var parts:Array = url.split("/");
         if((parts[0] as String).toLowerCase() != "pvpnet:")
         {
            return null;
         }
         if((parts[2] as String).toLowerCase() != "lol")
         {
            return null;
         }
         if((parts[3] as String).toLowerCase() != "customgame")
         {
            return null;
         }
         if((parts[4] as String).toLowerCase() != "joinorcreate")
         {
            return null;
         }
         firstSegmentIndex = 5;
         lastSegmentIndex = 8;
         game = new PracticeGameConfig();
         try
         {
            game.gameMap = this.config.getMapById(this.getPathValue(parts,firstSegmentIndex,lastSegmentIndex,"map"));
            variant = GameFlowVariantFactory.instance.getVariant(null,null);
            game.gameMode = variant.getGameModeForMap(game.gameMap.mapId);
            pickString = this.getPathValue(parts,firstSegmentIndex,lastSegmentIndex,"pick");
            game.gameTypeConfig = parseInt(pickString);
            if(!this.config.isGameTypeValid(game.gameTypeConfig))
            {
               return null;
            }
            numPlayers = 2 * parseInt(this.getPathValue(parts,firstSegmentIndex,lastSegmentIndex,"team"));
            if(numPlayers < game.gameMap.minCustomPlayers || numPlayers > game.gameMap.totalPlayers)
            {
               return null;
            }
            game.maxNumPlayers = numPlayers;
            game.allowSpectators = this.getPathValue(parts,firstSegmentIndex,lastSegmentIndex,"spec");
            if(!AllowSpectators.isValid(game.allowSpectators))
            {
               return null;
            }
            json = Base64Url.decode(parts[parts.length - 1]);
            dynamicParams = jsonDecode(json);
            game.gameName = dynamicParams["name"];
            game.gamePassword = dynamicParams["password"];
            game.passbackUrl = dynamicParams["report"];
            game.passbackDataPacket = dynamicParams["extra"];
            return game;
         }
         catch(e:Error)
         {
            return null;
         }
      }
      
      public function generateJoinOrCreatePracticeGameUrl(param1:PracticeGameConfig) : String
      {
         var _loc2_:String = "pvpnet://lol/customgame/joinorcreate/";
         _loc2_ += "map" + param1.gameMap.mapId.toString() + "/";
         _loc2_ += "pick" + param1.gameTypeConfig.toString() + "/";
         _loc2_ += "team" + (param1.maxNumPlayers * 0.5).toString() + "/";
         _loc2_ += "spec" + param1.allowSpectators + "/";
         var _loc3_:Object = {"name":param1.gameName};
         if(param1.gamePassword != null && param1.gamePassword.length > 0)
         {
            _loc3_["password"] = param1.gamePassword;
         }
         if(param1.passbackUrl != null)
         {
            _loc3_["report"] = param1.passbackUrl;
         }
         if(param1.passbackDataPacket != null)
         {
            _loc3_["extra"] = param1.passbackDataPacket;
         }
         var _loc4_:String = jsonEncode(_loc3_);
         return _loc2_ + Base64Url.encode(_loc4_);
      }
   }
}

