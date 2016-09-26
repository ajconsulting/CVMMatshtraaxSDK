//
//  ViewController.m
//  DemoTrackBrowser
//
//  Created by Nigel Grange on 22/08/2016.
//  Copyright © 2016 MashtraxxLtd. All rights reserved.
//

#import "ViewController.h"
#import "MXProgressHUD.h"
#import "AudioViewController.h"
#import "ExploreAudioViewController.h"

#import <MashtraxxSDK/MashtraxxSDK.h>

#define SDK_SECRET @"b5f86592-b5ea-49f1-a439-9a3d45c8f36b"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MXCloudTrackProvider* cloudTrackProvider;
@property (nonatomic, strong) NSDictionary* allTracks;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    self.allTracks = [self.cloudTrackProvider allAvailableTracksByGenre];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


-(void)loadAudioForSelectedTrack:(MXAvailableAudioTrack*)track
{
    MXProgressHUD* hud = [MXProgressHUD new];
    MXAudioCacheDev* audioCache = [[MXAudioCacheDev alloc] initWithSecret:SDK_SECRET];
    [audioCache provideAudioURLForTrack:track progress:hud completion:^{
        // track.audioUrl now contans the URL to the cached audio stream
        [hud hideProgressIndicator];
        [self showAudioEditorFoTrack:track];
        
    } onError:^(NSError *error) {
        [hud hideProgressIndicator];
        [self showError:error];
    }];
}

-(void)showAudioEditorFoTrack:(MXAvailableAudioTrack*)track
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Select Editor" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Slice Preview" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AudioViewController* vc = [[AudioViewController alloc] initWithNibName:@"AudioViewController" bundle:nil];
        [vc configureWithAudioTrack:track];
        [self presentViewController:vc animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Timeline Creator" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ExploreAudioViewController* vc = [[ExploreAudioViewController alloc] initWithNibName:@"AudioViewController" bundle:nil];
        [vc configureWithAudioTrack:track];
        [self presentViewController:vc animated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)showError:(NSError*)error
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString* genre = [self.allTracks allKeys][indexPath.section];
    NSArray* tracksInGenre = self.allTracks[genre];
    MXAvailableAudioTrack* track = tracksInGenre[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = track.trackTitle;
    cell.detailTextLabel.text = track.artist;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.allTracks allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* genre = [self.allTracks allKeys][section];
    NSArray* tracksInGenre = self.allTracks[genre];
    return [tracksInGenre count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* genre = [self.allTracks allKeys][section];
    return genre;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* genre = [self.allTracks allKeys][indexPath.section];
    NSArray* tracksInGenre = self.allTracks[genre];
    MXAvailableAudioTrack* track = tracksInGenre[indexPath.row];
    [self loadAudioForSelectedTrack:track];
}



@end
