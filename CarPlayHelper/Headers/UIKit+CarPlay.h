//
// Copyright (C) 2017 Daniel Martinez Gonzalez, S.A - All Rights Reserved
//
// This file is part of Daniel Martinez Gonzalez CarPlay.
//
// Unauthorized reproduction, copying, or modification, of this file, via
// any medium is strictly prohibited.
//
// This code is Proprietary and Confidential.
//
// All the 3rd parties libraries included in the project are regulated by
// their own licenses.
//
//

static const UIButtonType UIButtonTypeCar = (UIButtonType)123;
static const UIUserInterfaceIdiom UIUserInterfaceIdiomCar = (UIUserInterfaceIdiom)3;


@interface UIScreen (CarPlay)

    + (UIScreen *)_carScreen;
    - (BOOL)_isCarScreen;

@end
