package com.riotgames.landing.dao
{
   import blix.action.UrlLoaderAction;
   import blix.context.Context;
   import blix.context.IContext;
   import com.riotgames.landing.FeaturedGame;
   import com.riotgames.landing.FeaturedGamesPlayer;
   import com.riotgames.landing.LandingPageConfig;
   import com.riotgames.landing.featuredgames.FeaturedGamesModel;
   import com.riotgames.landing.featuredgames.QueueTypeHelper;
   import com.riotgames.util.logging.getLogger;
   import flash.events.HTTPStatusEvent;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import mx.logging.ILogger;
   
   public class FeaturedGameDao extends Context
   {
      
      private var _logger:ILogger = getLogger(this);
      
      private var _featuredGamesUrl:String;
      
      private var _championData:Object;
      
      private var _cacheAge:Number = 0;
      
      private var _queueTypeHelper:QueueTypeHelper;
      
      public function FeaturedGameDao(param1:LandingPageConfig, param2:IContext)
      {
         super(param2);
         this._featuredGamesUrl = param1.featuredGamesUrl;
         this._championData = param1.championData;
         this._queueTypeHelper = new QueueTypeHelper();
      }
      
      public function loadFeaturedGamesData(param1:Function, param2:Function = null) : void
      {
         var urlLoaderAction:UrlLoaderAction = null;
         var completedHandler:Function = param1;
         var erredHandler:Function = param2;
         var url:String = this._featuredGamesUrl;
         this._logger.info("Featured Games url: " + url);
         if(url)
         {
            urlLoaderAction = new UrlLoaderAction(new URLRequest(url));
            urlLoaderAction.unmarshallDataFunction = this.parseFeaturedGameData;
            urlLoaderAction.getUrlLoader().addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.handleResponseStatus);
            urlLoaderAction.getCompleted().add(function():void
            {
               completedHandler(urlLoaderAction.unmarshalledData);
            });
            urlLoaderAction.getErred().add(function():void
            {
               erredHandler(urlLoaderAction.getError());
            });
            urlLoaderAction.invoke();
         }
      }
      
      private function handleResponseStatus(param1:HTTPStatusEvent) : void
      {
         var _loc2_:URLRequestHeader = null;
         for each(_loc2_ in param1.responseHeaders)
         {
            if(_loc2_.name == "Age")
            {
               this._cacheAge = int(_loc2_.value);
            }
         }
      }
      
      private function parseFeaturedGameData(param1:String) : FeaturedGamesModel
      {
         var myFeaturedGames:Vector.<FeaturedGame> = null;
         var featuredGameObj:Object = null;
         var myFeaturedGame:FeaturedGame = null;
         var participants:Object = null;
         var myFeaturedGamesPlayer:FeaturedGamesPlayer = null;
         var path:String = null;
         var data:String = param1;
         var myFeaturedGamesModel:FeaturedGamesModel = new FeaturedGamesModel();
         var obj:Object = null;
         try
         {
            obj = JSON.parse(data);
         }
         catch(error:Error)
         {
            _logger.error("Invalid featured games data.");
            return null;
         }
         if(obj != null)
         {
            if(obj.gameList.length > 0)
            {
               myFeaturedGames = new Vector.<FeaturedGame>();
               for each(featuredGameObj in obj.gameList)
               {
                  myFeaturedGame = new FeaturedGame(featuredGameObj);
                  myFeaturedGame.gameId = featuredGameObj.gameId;
                  myFeaturedGame.gameMode = featuredGameObj.gameMode;
                  myFeaturedGame.gameType = featuredGameObj.gameType;
                  myFeaturedGame.mapId = featuredGameObj.mapId;
                  myFeaturedGame.queueType = this._queueTypeHelper.getQueueTypeById(featuredGameObj.gameQueueConfigId ? int(featuredGameObj.gameQueueConfigId) : -1);
                  myFeaturedGame.encryptionKey = featuredGameObj.observers.encryptionKey;
                  myFeaturedGame.platformId = featuredGameObj.platformId;
                  myFeaturedGame.downloadTime = new Date().time;
                  myFeaturedGame.gameStartTime = !featuredGameObj.gameLength ? new Date().time - featuredGameObj.gameStartTime : featuredGameObj.gameLength * 1000;
                  myFeaturedGame.participants = new Vector.<FeaturedGamesPlayer>();
                  for each(participants in featuredGameObj.participants)
                  {
                     myFeaturedGamesPlayer = new FeaturedGamesPlayer();
                     myFeaturedGamesPlayer.championId = participants.championId;
                     myFeaturedGamesPlayer.profileIconId = participants.profileIconId;
                     myFeaturedGamesPlayer.skinIndex = participants.skinIndex;
                     myFeaturedGamesPlayer.spell1Id = participants.spell1Id;
                     myFeaturedGamesPlayer.spell2Id = participants.spell2Id;
                     myFeaturedGamesPlayer.summonerName = participants.summonerName;
                     myFeaturedGamesPlayer.teamId = participants.teamId;
                     path = "";
                     if(Boolean(this._championData) && Boolean(this._championData[participants.championId]))
                     {
                        path = "app:/assets/images/champions/" + this._championData[participants.championId].skinName + "_square_0.png";
                     }
                     myFeaturedGamesPlayer.championIconPath = path;
                     myFeaturedGame.participants.push(myFeaturedGamesPlayer);
                  }
                  myFeaturedGame.cacheAge = this._cacheAge;
                  myFeaturedGames.push(myFeaturedGame);
               }
            }
            myFeaturedGamesModel.clientRefreshInterval = obj.clientRefreshInterval * 1000;
            myFeaturedGamesModel.featuredGames = myFeaturedGames;
         }
         return myFeaturedGamesModel;
      }
   }
}

