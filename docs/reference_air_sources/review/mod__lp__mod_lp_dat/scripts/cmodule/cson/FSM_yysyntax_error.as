package cmodule.cson
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   import avm2.intrinsics.memory.sxi8;
   
   public final class FSM_yysyntax_error extends Machine
   {
      
      public function FSM_yysyntax_error()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         cmodule.cson.mstate.esp -= 4;
         si32(cmodule.cson.mstate.ebp,cmodule.cson.mstate.esp);
         cmodule.cson.mstate.ebp = cmodule.cson.mstate.esp;
         cmodule.cson.mstate.esp -= 96;
         _loc1_ = cmodule.cson._yypact;
         _loc2_ = li32(cmodule.cson.mstate.ebp + 12);
         _loc1_ += _loc2_;
         _loc1_ = li8(_loc1_);
         _loc2_ = _loc1_ << 24;
         _loc2_ >>= 24;
         _loc3_ = cmodule.cson.mstate.ebp + -96;
         _loc4_ = cmodule.cson.mstate.ebp + -64;
         _loc5_ = li32(cmodule.cson.mstate.ebp + 8);
         _loc6_ = li32(cmodule.cson.mstate.ebp + 16);
         _loc7_ = _loc2_ + 8;
         if(uint(_loc7_) >= uint(37))
         {
            _loc1_ = 0;
         }
         else
         {
            if(uint(_loc6_) >= uint(274))
            {
               _loc6_ = 2;
            }
            else
            {
               _loc7_ = cmodule.cson._yytranslate;
               _loc6_ = _loc7_ + _loc6_;
               _loc6_ = li8(_loc6_);
            }
            _loc7_ = cmodule.cson._yytname;
            _loc6_ <<= 2;
            _loc6_ = _loc7_ + _loc6_;
            _loc6_ = li32(_loc6_);
            _loc7_ = li8(_loc6_);
            _loc8_ = _loc6_;
            loop17:
            while(true)
            {
               while(true)
               {
                  if(_loc7_ != 34)
                  {
                     break;
                  }
                  _loc9_ = si8(li8(_loc8_ + 1));
                  _loc10_ = _loc8_ + 1;
                  while(true)
                  {
                     if(_loc9_ <= 43)
                     {
                        if(_loc9_ != 34)
                        {
                           if(_loc9_ == 39)
                           {
                              break;
                           }
                           addr01ed:
                           _loc9_ = 0;
                           loop0:
                           while(true)
                           {
                              _loc12_ = _loc8_;
                              _loc11_ = _loc7_;
                              _loc8_ = _loc10_;
                              _loc7_ = 0;
                              _loc10_ = _loc8_;
                              while(true)
                              {
                                 _loc13_ = _loc10_ + _loc7_;
                                 _loc13_ = si8(li8(_loc13_ + 1));
                                 _loc7_ += 1;
                                 if(_loc13_ > 43)
                                 {
                                    if(_loc13_ != 92)
                                    {
                                       if(_loc13_ == 44)
                                       {
                                          break;
                                       }
                                       continue;
                                    }
                                    addr0246:
                                    _loc7_ += -1;
                                    _loc9_ = _loc7_ + _loc9_;
                                    _loc10_ = _loc9_ + 1;
                                    _loc8_ += _loc7_;
                                    _loc9_ = _loc12_;
                                    _loc7_ = _loc11_;
                                    _loc11_ = li8(_loc8_ + 2);
                                    _loc12_ = _loc8_ + 2;
                                    if(_loc11_ != 92)
                                    {
                                       _loc8_ = _loc9_;
                                       addr016c:
                                       break loop17;
                                    }
                                    continue loop0;
                                 }
                                 if(_loc13_ != 34)
                                 {
                                    if(_loc13_ == 39)
                                    {
                                       break;
                                    }
                                    continue;
                                 }
                                 _loc7_ += _loc9_;
                                 _loc8_ = _loc12_;
                              }
                              _loc8_ = _loc12_;
                              _loc7_ = _loc11_;
                              §§goto(addr016c);
                              _loc8_ = _loc9_;
                              _loc9_ = _loc10_;
                              _loc10_ = _loc12_;
                           }
                           break;
                           addr0278:
                        }
                        else
                        {
                           _loc7_ = 0;
                        }
                        §§goto(addr0310);
                     }
                     else
                     {
                        if(_loc9_ == 44)
                        {
                           break;
                        }
                        if(_loc9_ == 92)
                        {
                           _loc10_ = 0;
                           _loc9_ = _loc8_;
                           §§goto(addr0246);
                        }
                        else
                        {
                           §§goto(addr01ed);
                        }
                     }
                     break;
                  }
                  break;
               }
               break;
            }
            _loc7_ &= 255;
            if(_loc7_ != 0)
            {
               _loc7_ = 0;
               do
               {
                  _loc9_ = _loc6_ + _loc7_;
                  _loc9_ = li8(_loc9_ + 1);
                  _loc7_ += 1;
               }
               while(_loc9_ != 0);
            }
            else
            {
               _loc7_ = 0;
            }
            addr0310:
            _loc6_ = _loc8_;
            _loc8_ = 115;
            _loc9_ = _loc1_ << 24;
            si32(_loc6_,cmodule.cson.mstate.ebp + -96);
            _loc6_ = 29 - _loc2_;
            _loc9_ >>= 24;
            _loc2_ = 0 - _loc2_;
            si8(_loc8_,cmodule.cson.mstate.ebp + -64);
            _loc2_ = _loc9_ < 0 ? _loc2_ : 0;
            _loc6_ = _loc6_ < 20 ? _loc6_ : 19;
            _loc8_ = cmodule.cson._yyunexpected_2E_4509;
            _loc9_ = cmodule.cson.mstate.ebp + -64;
            _loc10_ = 0;
            do
            {
               _loc11_ = _loc8_ + _loc10_;
               _loc11_ = li8(_loc11_ + 1);
               _loc12_ = _loc4_ + _loc10_;
               si8(_loc11_,_loc12_ + 1);
               _loc10_ += 1;
            }
            while(_loc11_ != 0);
            _loc8_ = cmodule.cson._yycheck;
            _loc1_ <<= 24;
            _loc1_ >>= 24;
            _loc11_ = cmodule.cson._yytname;
            _loc12_ = _loc2_ << 2;
            _loc14_ = cmodule.cson._yyexpecting_2E_4510;
            _loc15_ = 0;
            _loc16_ = 1;
            _loc10_ = _loc4_ + _loc10_;
            _loc11_ += _loc12_;
            _loc17_ = _loc8_ + _loc1_;
            _loc12_ = _loc11_;
            _loc13_ = _loc2_;
            _loc1_ = _loc16_;
            _loc2_ = _loc14_;
            _loc11_ = _loc15_;
            _loc8_ = _loc7_;
            loop4:
            while(true)
            {
               _loc16_ = _loc12_;
               _loc15_ = _loc13_;
               _loc14_ = _loc1_;
               _loc13_ = _loc2_;
               _loc1_ = _loc12_ = _loc10_;
               _loc2_ = _loc13_;
               _loc10_ = _loc16_;
               if(_loc15_ < _loc6_)
               {
                  _loc18_ = _loc17_ + _loc15_;
                  _loc18_ = si8(li8(_loc18_));
                  if(_loc18_ == _loc15_)
                  {
                     if(_loc15_ != 1)
                     {
                        if(_loc14_ == 5)
                        {
                           _loc1_ = 0;
                           si8(_loc1_,cmodule.cson.mstate.ebp + -37);
                           _loc1_ = li8(_loc9_);
                           if(_loc1_ != 0)
                           {
                              _loc1_ = 1;
                              _loc2_ = _loc7_;
                              break;
                           }
                           addr0794:
                           addr0b96:
                           _loc1_ = 0;
                           _loc2_ = 1;
                           _loc10_ = _loc7_;
                           addr0794:
                           _loc4_ = _loc10_;
                           _loc1_ += _loc4_;
                           _loc4_ = uint(_loc1_) < uint(_loc4_) ? 1 : 0;
                           _loc4_ = _loc4_ & 1;
                           _loc4_ = _loc4_ | _loc11_;
                           if(_loc4_ != 0)
                           {
                              _loc1_ = -1;
                           }
                           else if(_loc5_ != 0)
                           {
                              _loc4_ = 0;
                              _loc6_ = _loc9_;
                              loop8:
                              while(true)
                              {
                                 _loc7_ = _loc5_;
                                 _loc10_ = _loc6_;
                                 _loc6_ = li8(_loc10_);
                                 si8(_loc6_,_loc7_);
                                 _loc11_ = _loc10_;
                                 _loc5_ = _loc7_;
                                 if(_loc6_ == 0)
                                 {
                                    break;
                                 }
                                 _loc12_ = 0;
                                 _loc6_ = _loc4_ << 2;
                                 _loc6_ = _loc3_ + _loc6_;
                                 _loc8_ = _loc12_;
                                 _loc9_ = _loc4_;
                                 _loc4_ = _loc12_;
                                 loop9:
                                 while(true)
                                 {
                                    _loc12_ = _loc7_ + _loc4_;
                                    _loc13_ = li8(_loc12_);
                                    _loc14_ = _loc6_;
                                    if(_loc13_ != 37)
                                    {
                                       break;
                                    }
                                    _loc13_ = _loc11_ + _loc8_;
                                    _loc13_ = li8(_loc13_ + 1);
                                    if(_loc13_ != 115)
                                    {
                                       break;
                                    }
                                    if(_loc9_ >= _loc2_)
                                    {
                                       break;
                                    }
                                    _loc13_ = li32(_loc14_);
                                    _loc14_ = li8(_loc13_);
                                    _loc15_ = _loc13_;
                                    loop19:
                                    while(true)
                                    {
                                       if(_loc14_ == 34)
                                       {
                                          _loc14_ = 0;
                                          _loc16_ = _loc15_;
                                          loop11:
                                          while(true)
                                          {
                                             _loc17_ = si8(li8(_loc16_ + 1));
                                             _loc18_ = _loc16_ + 1;
                                             loop20:
                                             while(true)
                                             {
                                                while(true)
                                                {
                                                   if(_loc17_ <= 43)
                                                   {
                                                      if(_loc17_ == 34)
                                                      {
                                                         break loop20;
                                                      }
                                                      if(_loc17_ == 39)
                                                      {
                                                         break loop11;
                                                      }
                                                   }
                                                   else
                                                   {
                                                      if(_loc17_ == 44)
                                                      {
                                                         break loop11;
                                                      }
                                                      if(_loc17_ == 92)
                                                      {
                                                         _loc17_ = li8(_loc16_ + 2);
                                                         _loc16_ += 2;
                                                         if(_loc17_ == 92)
                                                         {
                                                            break;
                                                         }
                                                         break loop11;
                                                      }
                                                   }
                                                   _loc16_ = _loc18_;
                                                   break;
                                                }
                                                while(true)
                                                {
                                                   _loc17_ = _loc14_;
                                                   _loc16_ = _loc14_ = _loc16_;
                                                   if(_loc12_ != 0)
                                                   {
                                                      _loc14_ = 0;
                                                      _loc18_ = _loc17_ + _loc4_;
                                                      _loc18_ = _loc18_ + _loc5_;
                                                      while(true)
                                                      {
                                                         _loc19_ = _loc16_ + _loc14_;
                                                         _loc20_ = li8(_loc19_);
                                                         _loc21_ = _loc18_ + _loc14_;
                                                         si8(_loc20_,_loc21_);
                                                         _loc19_ = si8(li8(_loc19_ + 1));
                                                         _loc14_ += 1;
                                                         if(_loc19_ <= 43)
                                                         {
                                                            if(_loc19_ == 34)
                                                            {
                                                               _loc14_ = _loc13_ = _loc17_ + _loc14_;
                                                               break loop20;
                                                            }
                                                            if(_loc19_ == 39)
                                                            {
                                                               break loop11;
                                                            }
                                                            continue;
                                                         }
                                                         if(_loc19_ == 44)
                                                         {
                                                            break;
                                                         }
                                                         if(_loc19_ != 92)
                                                         {
                                                            continue;
                                                         }
                                                         _loc16_ += _loc14_;
                                                         _loc16_ = _loc16_ + -1;
                                                         _loc14_ = _loc17_ + _loc14_;
                                                         §§goto(addr08c4);
                                                      }
                                                      break loop11;
                                                   }
                                                   continue loop11;
                                                   addr08c4:
                                                }
                                                break loop8;
                                             }
                                             _loc17_ += 1;
                                             _loc16_ = _loc14_;
                                             _loc14_ = _loc17_;
                                             _loc13_ = _loc14_;
                                             if(_loc12_ == 0)
                                             {
                                                _loc6_ = _loc9_ + 1;
                                                _loc9_ = _loc13_;
                                                break loop19;
                                             }
                                             _loc12_ = 0;
                                             _loc4_ += _loc13_;
                                             _loc13_ = _loc7_ + _loc4_;
                                             si8(_loc12_,_loc13_);
                                             _loc12_ = _loc11_ + _loc8_;
                                             _loc12_ = li8(_loc12_ + 2);
                                             si8(_loc12_,_loc13_);
                                             _loc6_ += 4;
                                             _loc8_ += 2;
                                             _loc9_ += 1;
                                             if(_loc12_ == 0)
                                             {
                                                break loop8;
                                             }
                                             continue loop9;
                                          }
                                       }
                                       break loop11;
                                    }
                                    _loc5_ = _loc6_;
                                    _loc6_ = _loc9_;
                                    _loc8_ += _loc10_;
                                    _loc4_ += _loc6_;
                                    _loc6_ = _loc8_ + 2;
                                    _loc8_ = _loc7_ + _loc4_;
                                    _loc4_ = _loc5_;
                                    _loc5_ = _loc8_;
                                    continue loop8;
                                 }
                                 _loc4_ += _loc7_;
                                 _loc5_ = _loc8_ | 1;
                                 _loc6_ = _loc4_ + 1;
                                 _loc7_ = _loc10_ + _loc5_;
                                 _loc4_ = _loc9_;
                                 _loc5_ = _loc6_;
                                 _loc6_ = _loc7_;
                              }
                           }
                           cmodule.cson.mstate.eax = _loc1_;
                           cmodule.cson.mstate.esp = cmodule.cson.mstate.ebp;
                           cmodule.cson.mstate.ebp = li32(cmodule.cson.mstate.esp);
                           cmodule.cson.mstate.esp += 4;
                           cmodule.cson.mstate.esp += 4;
                           return;
                        }
                        _loc12_ = cmodule.cson.mstate.ebp + -96;
                        _loc13_ = _loc14_ << 2;
                        _loc10_ = li32(_loc10_);
                        _loc12_ += _loc13_;
                        si32(_loc10_,_loc12_);
                        _loc12_ = li8(_loc10_);
                        _loc13_ = _loc14_ + 1;
                        _loc14_ = _loc10_;
                        loop22:
                        while(true)
                        {
                           while(true)
                           {
                              if(_loc12_ == 34)
                              {
                                 _loc18_ = si8(li8(_loc10_ + 1));
                                 _loc19_ = _loc10_ + 1;
                                 if(_loc18_ <= 43)
                                 {
                                    if(_loc18_ == 34)
                                    {
                                       break;
                                    }
                                    if(_loc18_ != 39)
                                    {
                                       addr0509:
                                       _loc10_ = 0;
                                       loop6:
                                       while(true)
                                       {
                                          _loc20_ = _loc12_;
                                          _loc18_ = _loc10_;
                                          _loc12_ = _loc19_;
                                          _loc10_ = 0;
                                          _loc19_ = _loc12_;
                                          while(true)
                                          {
                                             _loc21_ = _loc19_ + _loc10_;
                                             _loc21_ = si8(li8(_loc21_ + 1));
                                             _loc10_ += 1;
                                             if(_loc21_ > 43)
                                             {
                                                if(_loc21_ != 92)
                                                {
                                                   if(_loc21_ == 44)
                                                   {
                                                      break;
                                                   }
                                                   continue;
                                                }
                                                addr0558:
                                                _loc10_ += -1;
                                                _loc19_ = _loc10_ + _loc18_;
                                                _loc19_ = _loc19_ + 1;
                                                _loc10_ = _loc12_ + _loc10_;
                                                _loc12_ = _loc20_;
                                                _loc18_ = _loc19_;
                                                _loc19_ = li8(_loc10_ + 2);
                                                _loc20_ = _loc10_ + 2;
                                                if(_loc19_ != 92)
                                                {
                                                   _loc10_ = _loc12_;
                                                   addr0488:
                                                   break loop22;
                                                }
                                                continue loop6;
                                             }
                                             if(_loc21_ != 34)
                                             {
                                                if(_loc21_ == 39)
                                                {
                                                   break;
                                                }
                                                continue;
                                             }
                                             _loc10_ += _loc18_;
                                             §§goto(addr0610);
                                          }
                                          _loc10_ = _loc20_;
                                          §§goto(addr0488);
                                          _loc10_ = _loc18_;
                                          _loc19_ = _loc20_;
                                       }
                                       continue loop4;
                                       addr058a:
                                    }
                                 }
                                 else if(_loc18_ != 44)
                                 {
                                    if(_loc18_ == 92)
                                    {
                                       _loc19_ = 0;
                                       §§goto(addr0558);
                                    }
                                    else
                                    {
                                       §§goto(addr0509);
                                    }
                                 }
                              }
                              _loc10_ = _loc12_;
                              break loop22;
                           }
                           _loc10_ = 0;
                           §§goto(addr0610);
                        }
                        _loc10_ &= 255;
                        if(_loc10_ == 0)
                        {
                           break loop23;
                        }
                        _loc10_ = 0;
                        do
                        {
                           _loc12_ = _loc14_ + _loc10_;
                           _loc12_ = li8(_loc12_ + 1);
                           _loc10_ += 1;
                        }
                        while(_loc12_ != 0);
                        addr0610:
                        _loc12_ = 0;
                        _loc14_ = _loc10_ + _loc8_;
                        _loc10_ = uint(_loc14_) < uint(_loc8_) ? 1 : 0;
                        _loc10_ = _loc10_ & 1;
                        _loc8_ = _loc10_ | _loc11_;
                        _loc10_ = _loc12_;
                        do
                        {
                           _loc11_ = _loc2_ + _loc10_;
                           _loc11_ = li8(_loc11_);
                           _loc12_ = _loc1_ + _loc10_;
                           si8(_loc11_,_loc12_);
                           _loc10_ += 1;
                        }
                        while(_loc11_ != 0);
                        _loc2_ = cmodule.cson._yyor_2E_4511;
                        _loc1_ += _loc10_;
                        _loc10_ = _loc1_ + -1;
                        _loc1_ = _loc13_;
                        _loc11_ = _loc8_;
                        _loc8_ = _loc14_;
                        continue;
                     }
                  }
                  _loc1_ = _loc14_;
                  _loc2_ = _loc13_;
                  _loc10_ = _loc12_;
                  continue;
               }
               _loc1_ = li8(_loc9_);
               if(_loc1_ != 0)
               {
                  _loc1_ = _loc14_;
                  _loc2_ = _loc8_;
                  break;
               }
               _loc1_ = 0;
               _loc2_ = _loc14_;
               _loc10_ = _loc8_;
               §§goto(addr0794);
               _loc12_ = _loc16_ + 4;
               _loc13_ = _loc15_ + 1;
            }
            _loc10_ = _loc2_;
            _loc2_ = 0;
            while(true)
            {
               _loc6_ = _loc4_ + _loc2_;
               _loc6_ = li8(_loc6_ + 1);
               _loc7_ = _loc2_ + 1;
               if(_loc6_ == 0)
               {
                  break;
               }
               _loc2_ = _loc7_;
            }
            _loc2_ = _loc1_;
            _loc1_ = _loc7_;
            §§goto(addr0794);
         }
         §§goto(addr0b96);
      }
   }
}

