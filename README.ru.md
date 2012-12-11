## Установка нужного софта
* [VirtualBox][vb]
* [Vagrant][vagrant]
* Ruby
	* *Windows* Ставим [Ruby][rubyinstall] 1.9.3
	* *\*nix/Mac* [RVM][rvm]

		```
		\curl -L https://get.rvm.io | bash -s stable --ruby
		rvm install 1.9.3
		rvm use 1.9.3
		```
* `gem install bundler librarian`
* `git clone https://github.com/vasilykraev/vagrant.git vagrant.git`
* `cd vagrant`
* `linrarian-chef install`


## Запуск

```
vagrant box add precise32 http://files.vagrantup.com/precise32.box
vagrant up
vagrant ssh # зайти по ssh на виртуалку
```


### Память
Чтобы изменить количество памяти, выделяемое виртуальной машине, надо отредактировать параметр в Vagrantfile:
`config.vm.customize ["modifyvm", :id, "--memory", "768"]`


### Домены
Например, чтобы создать test.vm, необходимо:

* Закачать файлы в public/test.vm
* Отредактировать переменную :hosts в Vagrantfile, `:hosts => [test.vm", "dev.vm"]`
* Перезапустить Vagrant `vagrant reload`
* Отредактировать файл hosts на основной машине, указать

	```
	127.0.0.1 dev.vm
	127.0.0.1 test.vm
	```
* После этого открыть в браузере *http://test.vm:8000*


### NFS
Для Windows нужно отключить Network File System. `config.vm.share_folder "v-data", "/vagrant", ".", :nfs => false`
Для nix систем рекомендуется использовать NFS, бенчмарки [показывают][vagrant-nfs], что при отключенном NFS, и в примонтированной папке находится более 1000 файлов, могут начаться тормоза.


### Сервисы
После инициализации виртуалки, будут доступны следующие сервисы, к которым можно прицепится соответствующим софтом (например mysql - Workbench, pgsql - Navicat):
* 127.0.0.1:2222 - ssh
* 127.0.0.1:3306 - mysql
* 127.0.0.1:5432 - pgsql
* 127.0.0.1:8000 - apache
* 127.0.0.1:8080 - jenkins



## I need moooreeee info!
### VirtualBox & Vagrant
Vagrant написан на языке Ruby и представляет собой обертку на VirtualBox. У VB есть режим командной строки, можно запускать виртуалку, менять ее параметры, и прочее. [Команды VirtualBox][vb-cli], вида:

```
VBoxManage createvm --name "Windows XP" --register
VBoxManage startvm "Windows XP"
VBoxManage modifyvm "VM name" --memory 1024
VBoxManage modifyvm "VM name" --intnet1 "network name" --macaddress1 auto
VBoxManage controlvm nic1 bridged
```

Vagrant предоставляет синтаксический сахар в виде [команд][vagrant-gs]:

```
vagrant box add precise32 http://files.vagrantup.com/precise32.box
vagrant up
vagrant halt
vagrant reload # halt + up
vagrant box --help
```

Вагрант привязывает виртуалку к полному пути на диске, т.е. если использовать одну и ту же сборку вагранта, но в разных папках, то будет запущено две одинаковые, но **отдельные** виртуальные машины

```
git clone https://github.com/vasilykraev/vagrant.git vagrant
git clone https://github.com/vasilykraev/vagrant.git vagrant2
cd vagrant; vagrant up
cd ../vagrant2; vagrant up
```


### VagrantFile & Chef cookbooks
VagrantFile – своего рода конфиг для виртуалки, написанный на языке Ruby. Для разворачивания и установки нужного софта используется Chef. Шеф при запуске смотрит, какие есть роли (например, на большой инфраструктуре frontend, backend, db-master, db-slave) и смотрит какие кукбуки (cookbook, поваренная книга) нужно запустить для данной роли.

Кукбук представляет собой сборник рецептов. В этой сборке, например, роль `drupal_lamp` представляет собой запуск нескольких кукбуков с выбором некоторых рецептов из них:

```
"recipe[apache2]",
"recipe[apache2::mod_ssl]",
"recipe[apache2::mod_expires]",
"recipe[apache2::mod_php5]",
"recipe[apache2::mod_rewrite]",
"recipe[mysql::server]",
"recipe[php::package]",
"recipe[php::module_mysql]",
"recipe[php::module_apc]",
"recipe[php::module_curl]",
"recipe[php::module_gd]",
"recipe[git]",
"recipe[drush]",
"recipe[drupal]"
```

Сами кукбуки не хранятся в репозитории, а загружаются из других репозитариев гитхаба с помощью установленного ранее  librarian и команды `librarian-chef install`. Это позволяет не засорять репозитарий, и иметь актуальную версию кукбуков. Все они перечислены в файле Cheffile. После запуска команды создается `Cheffile.lock` в нем прописываются версии и хэш коммита, файл можно использовать в дальнейшем, если все ок. Для того, чтобы загрузить последние версии кукбуков, `Cheffile.lock` надо удалить (т.е.  автор кукбука мог внести изменения, и сборка не проходит полностью). 
Например, такое было, когда кукбук mysql обновился с 1.3 до 2.0, и нужно было дополнительно указать пару паролей для mysql-сервера, а если они не были указаны – Chef останавливался.


### Почему нужно ставить RVM для nix, а не использовать системный
1. В системе чаще всего стоит старая версия, например 1.8.7, и с ней могут быть проблемы.
2. Потому что rvm ставится в `~/.rvm`, и все гемы (gems, модули для Ruby), устанавливает в соответствующую папку, например `~/.rvm/gems/ruby-1.9.3-p286/`, соответственно не засоряется система, и при желании легко можно удалить саму RVM и все установленные версии Ruby и Gems, попросту удалив папку `~/.rvm`
3. Можно иметь несколько разных версий Ruby в системе. Хотя, для разработчиков на PHP это некритично :)



[vb]: https://www.virtualbox.org/wiki/Downloads
[vb-cli]: http://www.virtualbox.org/manual/ch08.html
[vagrant]: http://vagrantup.com/
[vagrant-gs]: http://vagrantup.com/v1/docs/getting-started/index.html
[vagrant-nfs]: http://vagrantup.com/v1/docs/nfs.html
[rvm]: https://rvm.io/rvm/install/
[rubyinstall]: http://rubyinstaller.org/downloads/