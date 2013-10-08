
# 入门指南

## 配置 Core Data Stack

开始前，在你的工程中先引入头文件*PKRecordKit.h*(比如在pch文件中引入，这样就可以整个工程都能用了)

接下来，需要配置一发，啥时候开始配置就看你了，可以在applicationDidFinishLaunching:(UIApplication \*) withOptions:(NSDictionary \*) 方法, 或者 awakeFromNib等方法中使用以下方法来配置一个 **PKRecord** :

	- (void)setupCoreDataStackInMemoryStore;

	- (void)setupCoreDataStackInStoreURL:(NSURL *)URL;

	- (void)setupCoreDataStackAutoMigratingInStoreURL:(NSURL *)URL;


以上任意一个配置方法都会创建一个rootContext和一个defaultContext,rootContext是连接DataModel的**'源上下文'**(这么说大丈夫？),他默认会连接mainBundle下的DataModel,当然也可以使用以下方法来设置读取特定DataModel:

	- (void)setModelName:(NSString *)name;

之所以全部用的是		

最后，在退出app前，你可以使用以下方法来清理掉相关上下文：

	- (void)cleanup;
	

## 保存 (可参考Demo中使用)


1.可以使用**PKRecordContext**的对象方法进行持久化,PKRecord配置好生成的rootContext和defaultContext都是该类生成的对象。

	- (void)saveOnlySelfWithCompletion:(PKSaveContextOnCompletedBlock)completed;

	- (void)saveOnlySelfAndWait;

	- (void)saveToPersistentStoreWithCompletion:(PKSaveContextOnCompletedBlock)completed;

	- (void)saveToPersistentStoreAndWait;

	- (void)saveWithOptions:(PKSaveContextOptions)options onCompleted:(PKSaveContextOnCompletedBlock)completed;



2.可以用**PKRecord**的对象方法进行持久化,内部实现也是用了rootContext和defaultContext的保存方法。

	- (void)saveUsingCurrentThreadContextWithBlock:(PKSavingBlock)block;

	- (void)saveUsingCurrentThreadContextWithBlock:(PKSavingBlock)block onCompleted:(PKSaveOnCompletedBlock)completed;

	- (void)saveAndWaitWithBlock:(PKSavingBlock)block;

	- (void)saveAndWaitUsingCurrentThreadContextWithBlock:(PKSavingBlock)block;

