/*
=================================================
CEApplication
(for CotEditor)

 Copyright (C) 2004-2007 nakamuxu.
 Copyright (C) 2014 CotEditor Project
 http://coteditor.github.io
=================================================

encoding="UTF-8"
Created:2005.09.06

-------------------------------------------------

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA. 


=================================================
*/

#import "CEApplication.h"
#import "constants.h"


@implementation CEApplication

#pragma mark NSApplication Methods

//=======================================================
// NSApplication method
//
//=======================================================

// ------------------------------------------------------
- (instancetype)init
// 初期化
// ------------------------------------------------------
{
    self = [super init];
    if (self) {
        [self setKeyCatchMode:k_keyDownNoCatch];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setKeyCatchModeWithNotification:)
                                                     name:k_setKeyCatchModeToCatchMenuShortcut
                                                   object:nil];
    }
    return self;
}


// ------------------------------------------------------
- (void)dealloc
// あとかたづけ
// ------------------------------------------------------
{
    // ノーティフィケーションセンタから自身を排除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// ------------------------------------------------------
- (void)sendEvent:(NSEvent *)anEvent
// keyDownイベントをキャッチする
// ------------------------------------------------------
{
    if (([self keyCatchMode] == k_catchMenuShortcut) && ([anEvent type] == NSKeyDown)) {
        NSString *charIgnoringMod = [anEvent charactersIgnoringModifiers];
        if ((charIgnoringMod != nil) && ([charIgnoringMod length] > 0)) {
            unichar theChar = [charIgnoringMod characterAtIndex:0];
            NSUInteger modifierFlags = [anEvent modifierFlags];
            NSCharacterSet *ignoringShiftSet = [NSCharacterSet characterSetWithCharactersInString:@"`~!@#$%^&()_{}|\":<>?=/*-+.'"];

            // Backspace または delete キーが押されていた時、是正する
            // （return 上の方にあるのが Backspace、テンキーとのあいだにある「delete」の刻印があるのが delete(forword)）
            if (theChar == NSDeleteCharacter) {
                unichar BSChar = NSBackspaceCharacter;
                charIgnoringMod = [NSString stringWithCharacters:&BSChar length:1];
            } else if (theChar == NSDeleteFunctionKey) {
                unichar deleteForwardChar = NSDeleteCharacter;
                charIgnoringMod = [NSString stringWithCharacters:&deleteForwardChar length:1];
            }
            // 不要なシフトを削除
            if ([ignoringShiftSet characterIsMember:[charIgnoringMod characterAtIndex:0]] &&
                (modifierFlags & NSShiftKeyMask)) {
                modifierFlags ^= NSShiftKeyMask;
            }
            NSDictionary *userInfo = @{k_keyBindingModFlags: @(modifierFlags),
                                       k_keyBindingChar: charIgnoringMod};
            [[NSNotificationCenter defaultCenter] postNotificationName:k_catchMenuShortcutNotification
                                                                object:self
                                                              userInfo:userInfo];
            [self setKeyCatchMode:k_keyDownNoCatch];
            return;
        }
    }
    [super sendEvent:anEvent];
}



#pragma mark Private Methods

//=======================================================
// Private method
//
//=======================================================

// ------------------------------------------------------
- (void)setKeyCatchModeWithNotification:(NSNotification *)aNotification
// ノーティフィケーションからキーキャッチモードを設定
// ------------------------------------------------------
{
    NSInteger mode = [[aNotification userInfo][k_keyCatchMode] integerValue];

    [self setKeyCatchMode:mode];
}

@end
