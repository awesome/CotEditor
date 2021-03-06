/*
=================================================
CESplitView
(for CotEditor)

 Copyright (C) 2004-2007 nakamuxu.
 Copyright (C) 2014 CotEditor Project
 http://coteditor.github.io
=================================================

encoding="UTF-8"
Created:2006.03.26

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

#import "CESplitView.h"
#import "constants.h"


@interface CESplitView ()

@property (nonatomic) BOOL finishedOpen;

@end

@implementation CESplitView

// ------------------------------------------------------
- (instancetype)initWithFrame:(NSRect)frameRect
// 初期化
// ------------------------------------------------------
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setFinishedOpen:NO];
        [self setDividerStyle:NSSplitViewDividerStylePaneSplitter];
    }
    return self;
}


// ------------------------------------------------------
- (void)setShowLineNum:(BOOL)showLineNum
// 行番号表示の有無を設定
// ------------------------------------------------------
{
    [[self subviews] makeObjectsPerformSelector:@selector(setShowLineNumWithNumber:)
                                     withObject:@(showLineNum)];
}


// ------------------------------------------------------
- (void)setShowNavigationBar:(BOOL)showNavigationBar
// ナビゲーションバー描画の有無を設定
// ------------------------------------------------------
{
    [[self subviews] makeObjectsPerformSelector:@selector(setShowNavigationBarWithNumber:)
                                     withObject:@(showNavigationBar)];
}


// ------------------------------------------------------
- (void)setWrapLines:(BOOL)wrapLines
// ラップする／しないを設定
// ------------------------------------------------------
{
    [[self subviews] makeObjectsPerformSelector:@selector(setWrapLinesWithNumber:)
                                     withObject:@(wrapLines)];
}


// ------------------------------------------------------
- (void)setShowInvisibles:(BOOL)showInvisibles
// 不可視文字の表示／非表示を設定
// ------------------------------------------------------
{
    [[self subviews] makeObjectsPerformSelector:@selector(setShowInvisiblesWithNumber:)
                                     withObject:@(showInvisibles)];
}


// ------------------------------------------------------
- (void)setUseAntialias:(BOOL)useAntialias
// 文字にアンチエイリアスを使うかどうかを設定
// ------------------------------------------------------
{
    [[self subviews] makeObjectsPerformSelector:@selector(setUseAntialiasWithNumber:)
                                     withObject:@(useAntialias)];
}


// ------------------------------------------------------
- (void)setCloseSubSplitViewButtonEnabled:(BOOL)enabled
// テキストビュー分割削除ボタンを有効／無効を設定
// ------------------------------------------------------
{
    [[self subviews] makeObjectsPerformSelector:@selector(updateCloseSubSplitViewButtonWithNumber:)
                                     withObject:@(enabled)];
}


// ------------------------------------------------------
- (void)setAllCaretToBeginning
// キャレットを先頭に移動
// ------------------------------------------------------
{
    [[self subviews] makeObjectsPerformSelector:@selector(setCaretToBeginning)];
}


// ------------------------------------------------------
- (void)releaseAllEditorView
// subSplitView が持つ editorView への参照を削除
// ------------------------------------------------------
{
    // （dealloc は親階層から行われるため、あらかじめ「子」が持っている「親」を開放しておく）
    [[self subviews] makeObjectsPerformSelector:@selector(releaseEditorView)];
}


// ------------------------------------------------------
- (void)setSyntaxStyleNameToSyntax:(NSString *)syntaxName
// シンタックススタイルを設定
// ------------------------------------------------------
{
    if (syntaxName == nil) { return; }

    [[self subviews] makeObjectsPerformSelector:@selector(setSyntaxStyleNameToSyntax:) withObject:syntaxName];
}


// ------------------------------------------------------
- (void)recoloringAllTextView
// 全てを再カラーリング、文書表示処理の完了をポスト（ここが最終地点）
// ------------------------------------------------------
{
    [[self subviews] makeObjectsPerformSelector:@selector(recoloringAllTextViewString)];
    if (![self finishedOpen]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:k_documentDidFinishOpenNotification
                                                            object:[self superview]]; // superView = CEEditorView
        [self setFinishedOpen:YES];
    }
}


// ------------------------------------------------------
- (void)updateAllOutlineMenu
// 全てのアウトラインメニューを再更新
// ------------------------------------------------------
{
    [[self subviews] makeObjectsPerformSelector:@selector(updateOutlineMenu)];
}


// ------------------------------------------------------
- (void)setAllBackgroundColorWithAlpha:(CGFloat)alpha
// 全てのテキストビューの背景不透明度を設定
// ------------------------------------------------------
{
    [[self subviews] makeObjectsPerformSelector:@selector(setBackgroundColorAlphaWithNumber:)
                                     withObject:@(alpha)];
}

@end
