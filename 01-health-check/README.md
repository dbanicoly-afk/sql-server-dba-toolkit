
# 🔍 SQL Server Health Check

![SQL Server](https://img.shields.io/badge/SQL_Server-9745F5?style=flat-square)
![T-SQL](https://img.shields.io/badge/T--SQL-BD93F9?style=flat-square)
![Read Only](https://img.shields.io/badge/Read_Only-5391FE?style=flat-square)

## 📖 Objetivo

Realizar um diagnóstico inicial da instância SQL Server, permitindo identificar características do ambiente, configurações e possíveis pontos de atenção.

## 📂 Scripts disponíveis

| Script | Descrição |
|---|---|
| [01-instance-health-check.sql](./01-instance-health-check.sql) | Diagnóstico geral da instância SQL Server |

## 🎯 Quando utilizar?

- Primeiro acesso a uma instância desconhecida.
- Investigação inicial de incidentes.
- Levantamento de informações do ambiente.
- Validação de configurações.
- Inventário de instâncias SQL Server.
- Apoio às rotinas de sustentação DBA.

## ⚙️ Como executar

1. Abra o SQL Server Management Studio (SSMS).
2. Conecte-se à instância desejada.
3. Abra uma nova janela de consulta.
4. Copie o conteúdo do script.
5. Execute e analise os resultados.

## 📊 Interpretando os resultados

### 01. Informações da instância

| Campo | Descrição |
|---|---|
| ServerName | Nome do servidor SQL |
| MachineName | Nome da máquina |
| InstanceName | Nome da instância |
| Edition | Edição do SQL Server |
| ProductVersion | Versão instalada |
| ProductLevel | Nível de atualização |
| ProductUpdateLevel | Atualização cumulativa, quando disponível |

Essas informações auxiliam na identificação da versão, edição e compatibilidade do ambiente.

### 02. Uptime e recursos

| Campo | Descrição |
|---|---|
| SQLServerStartTime | Última inicialização do serviço SQL |
| ApproximateUptimeDays | Tempo aproximado de atividade em dias |
| LogicalCPUCount | Quantidade de CPUs lógicas reportadas |
| SchedulerCount | Quantidade de schedulers reportados |
| PhysicalMemoryMB | Memória física em MB |
| SQLCommittedMemoryMB | Memória comprometida pelo gerenciador de memória SQL |
| SQLTargetMemoryMB | Meta de memória do gerenciador de memória SQL |

Um uptime baixo pode indicar uma reinicialização recente do serviço.

O consumo elevado de memória, isoladamente, não caracteriza um problema de performance.

### 03. Configurações de memória

| Configuração | Descrição |
|---|---|
| min server memory | Limite mínimo configurado para o gerenciador de memória |
| max server memory | Limite máximo configurado para a memória gerenciada pelo SQL Server |

Compare os valores configurados com os valores em uso.

A configuração deve considerar os recursos disponíveis, a carga de trabalho e as necessidades do sistema operacional.

O Max Server Memory não representa um limite absoluto para todo o consumo de memória do processo SQL Server.

### 04. Status dos bancos

| Campo | Descrição |
|---|---|
| DatabaseName | Nome do banco |
| DatabaseStatus | Estado atual |
| RecoveryModel | Modelo de recuperação |
| CompatibilityLevel | Nível de compatibilidade |
| UserAccess | Modo de acesso |
| PageVerify | Método de verificação de páginas |
| IsReadOnly | Indica se o banco é somente leitura |
| AutoClose | Configuração de fechamento automático |
| AutoShrink | Configuração de redução automática |
| CreationDate | Data de criação registrada |

### Pontos de atenção

- Bancos em estado SUSPECT ou RECOVERY_PENDING.
- Bancos inesperadamente OFFLINE.
- AUTO_SHRINK habilitado.
- AUTO_CLOSE habilitado sem justificativa.
- PAGE_VERIFY diferente de CHECKSUM.
- Configurações de memória incompatíveis com a necessidade do ambiente.

Esses pontos devem ser investigados antes de qualquer alteração.

## 🔐 Permissões

Para consultar sys.dm_os_sys_info:

- SQL Server 2019 e anteriores: VIEW SERVER STATE.
- SQL Server 2022 e posteriores: VIEW SERVER PERFORMANCE STATE.

A visibilidade dos bancos de dados depende das permissões do usuário.

## 🛡️ Segurança e impacto

- Consulta somente leitura.
- Não altera dados ou configurações persistentes.
- Não executa operações de manutenção.
- Baixo impacto esperado.

## 🧪 Compatibilidade e validação

- Compatibilidade prevista: SQL Server 2016 ou superior.
- Executado com sucesso em ambiente de teste.
- Validação em outras versões: pendente.

## 📌 Limitações

Este script representa uma avaliação inicial da instância.

Não substitui análises específicas de performance, integridade, memória, armazenamento ou disponibilidade.

Os resultados devem ser interpretados considerando as características de cada ambiente.

---

[Voltar ao repositório principal](../README.md)
