//
//  ViewController.m
//  限制输入长度
//
//  Created by zhuming on 15/12/21.
//  Copyright (c) 2015年 zhuming. All rights reserved.
//

#import "ViewController.h"

#define LENGTH 6

@interface ViewController ()<UITextFieldDelegate>

//textField输入框
@property (weak, nonatomic) IBOutlet UITextField *textField;
//颜色状态指示
@property (weak, nonatomic) IBOutlet UIView *stateView;
// textField输入的字符串
@property (nonatomic,strong)NSString *inputStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    // 方法二： 键值监听
    [self addObserver:self forKeyPath:@"inputStr" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 移除键值监听
    [self removeObserver:self forKeyPath:@"inputStr"];
}

#pragma mark - initView
- (void)initView{
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.stateView.backgroundColor = [UIColor redColor]; // 红色表示长度不是11位时的状态
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 方式二：
    self.inputStr = textField.text;
    // 方式一：
    //下面代码实现  手机号码为空或未输入LENGTH位数字时的状态
    if (textField.text.length < LENGTH - 1) {
        self.stateView.backgroundColor = [UIColor redColor]; // 红色表示长度不是LENGTH位时的状态
    }
    else if(textField.text.length == LENGTH - 1){
        if (range.location == LENGTH - 2) { // 点击键盘的删除按钮textField.text.length 会变为LENGTH
            self.stateView.backgroundColor = [UIColor redColor]; // 红色表示长度不是LENGTH位时的状态
        }
        else{ // 输入的长度是LENGTH位
            self.stateView.backgroundColor = [UIColor greenColor]; // 绿色表示长度是LENGTH位时的状态
        }
    }
    else{ // 大于LENGTH位
        if (range.location == LENGTH - 1) { // 点击键盘的删除按钮textField.text.length 会变为LENGTH
            self.stateView.backgroundColor = [UIColor redColor]; // 红色表示长度不是LENGTH位时的状态
        }
    }
    //限制输入长度是LENGTH位
    if (string.length == 0){
        return YES;
    }
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > LENGTH) {
        return NO;
    }
    return YES;
}
#pragma mark - textFieldDidChange
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > LENGTH) {
        textField.text = [textField.text substringToIndex:LENGTH - 1];
    }
}

// 方式二：键值监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"change = %@",change);
    NSString *str = change[@"new"];
    if (str.length == LENGTH - 1) {
        self.stateView.backgroundColor = [UIColor greenColor]; // 绿色表示长度是LENGTH位时的状态
    }
    else{
        self.stateView.backgroundColor = [UIColor redColor]; // 红色表示长度不是LENGTH位时的状态
    }
}
@end
