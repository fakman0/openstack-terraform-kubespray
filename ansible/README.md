# Ansible ile Otomatik Bastion Host Yapılandırması

Bu dizin, OpenStack üzerinde oluşturulan Kubernetes kümesini yapılandırmak için gerekli Ansible dosyalarını içerir. Ansible, Terraform tarafından oluşturulan `master-1` sunucusunu otomatik olarak bastion host olarak kullanacak şekilde yapılandırılmıştır.

## Genel Bakış

Bu yapılandırma, aşağıdaki bileşenlerden oluşur:

1. **Terraform Çıktı İşleme**: Terraform çıktıları JSON olarak kaydedilir ve Ansible tarafından kullanılır.
2. **Dinamik Envanter**: Terraform çıktılarından otomatik olarak Ansible envanter dosyası oluşturulur.
3. **Otomatik Bastion Yapılandırması**: `master-1` sunucusu bastion host olarak yapılandırılır ve tüm Ansible komutları bu sunucu üzerinden yönlendirilir.
4. **SSH Anahtar Yönetimi**: SSH anahtarları otomatik olarak kullanılır.

## Kurulum ve Çalıştırma

Terraform uygulamasını çalıştırdıktan sonra, kurulumu tamamlamak için aşağıdaki adımları izleyin:

### 1. Dosya İzinlerini Ayarlama

Öncelikle, script dosyalarını çalıştırılabilir yapın:

```bash
chmod +x setup_venv.sh setup_ansible.sh
```

### 2. Python Sanal Ortamını Kurma

Gerekli Python bağımlılıklarını kurmak için sanal ortam oluşturun:

```bash
./setup_venv.sh
```

Bu komut aşağıdakileri gerçekleştirir:
- Python sanal ortamı (.venv) oluşturur
- PyYAML kütüphanesini yükler
- Ansible yapılandırmasını otomatik olarak oluşturur

### 3. Manuel Kurulum (İsteğe Bağlı)

Eğer sanal ortamı manuel olarak oluşturmak isterseniz:

```bash
# Sanal ortam oluştur
python3 -m venv .venv

# Sanal ortamı aktive et
source .venv/bin/activate

# Bağımlılıkları yükle
pip install PyYAML

# Ansible yapılandırmasını oluştur
./setup_ansible.sh
```

## SSH Yapılandırması

Bastion host üzerinden bağlantı için SSH anahtarınızı agent'a eklemeniz gerekir:

```bash
ssh-add ~/.ssh/id_rsa  # veya kullandığınız diğer anahtar
```

Bu, anahtarınızın bastion sunucusu üzerinden diğer sunuculara aktarılmasını sağlar.

## Nasıl Çalışır?

Bastion host (master-1) yapılandırması iki şekilde gerçekleştirilir:

1. **ansible.cfg Yapılandırması**: Tüm SSH bağlantıları için ProxyCommand tanımlanır
   ```ini
   [ssh_connection]
   ssh_args = -o ForwardAgent=yes ... -o ProxyCommand="ssh -W %h:%p ... ubuntu@BASTION_IP"
   ```

2. **Envanter Yapılandırması**: master-1 bastion host olarak işaretlenir

Bu sayede, kişisel bilgisayarınızdaki ayarlara dokunmadan, Ansible tüm sunuculara bastion host üzerinden erişebilir.

## Komutları Çalıştırma

Ansible komutlarını normal şekilde çalıştırabilirsiniz:

```bash
cd ansible
ansible all -m ping  # Tüm sunuculara ping at
ansible-playbook playbooks/your-playbook.yml  # Playbook çalıştır
```

## Sorun Giderme

Eğer bağlantı sorunları yaşıyorsanız:

1. SSH anahtarınızın agent'a eklendiğinden emin olun:
   ```bash
   ssh-add -l  # Yüklü anahtarları listele
   ```

2. Bastion host'a doğrudan bağlanabildiğinizi kontrol edin:
   ```bash
   ssh ubuntu@BASTION_IP
   ```

3. Verbose modunda Ansible çalıştırın:
   ```bash
   ansible -vvv all -m ping
   ``` 