unit uApuracaoIcmsClass;

interface

uses uAttributes;

Type
[TableName('TAB_APURACAO_ICMS')]
 TapuracaoIcms = class
private
    FANO_MES                                 :String;
    FCOD_FILIAL                              :String;
    FDATA_INICIAL                            :Tdate;
    FDATA_FINAL                              :Tdate;
    FDEB_VLR_APURADO                         :Double;
    FDEB_VLR_OUTROS                          :Double;
    FDEB_DESC_OUTROS                         :String;
    FDEB_VLR_AJUST                           :Double;
    FDEB_VLR_ESTORNO                         :Double;
    FDEB_DESC_ESTORNO                        :String;
    FCRE_VLR_APURADO                         :Double;
    FCRE_VLR_OUTROS                          :Double;
    FCRE_DESC_OUTROS                         :String;
    FCRE_VLR_ESTORNO                         :Double;
    FCRE_DESC_ESTORNO                        :String;
    FCRE_VLR_SUBTOTAL                        :Double;
    FCRE_VLR_PERIODO_ANT                     :Double;
    FCRE_VLR_TOT                             :Double;
    FSAL_VLR_DEVEDOR                         :Double;
    FSAL_VLR_DEDUCOES                        :Double;
    FSAL_DESC_DEDUCOES                       :String;
    FSAL_VLR_IMPOSTO                         :Double;
    FSAL_VLR_SALDO_CREDOR                    :Double;
    FDEB_VLR_TOTAL                           :Double;
    FSTATUS                                  :String;
public

     [PrimaryKey('ANO_MES', '')]
    property ANO_MES             :String read   FANO_MES             write   FANO_MES;

     [PrimaryKey('COD_FILIAL', '')]
    property COD_FILIAL          :String read   FCOD_FILIAL          write   FCOD_FILIAL;

     [FieldName('DATA_INICIAL')]
    property DATA_INICIAL        :Tdate read   FDATA_INICIAL        write   FDATA_INICIAL;
     [FieldName('DATA_FINAL')]
    property DATA_FINAL          :Tdate read   FDATA_FINAL          write   FDATA_FINAL;
     [FieldName('DEB_VLR_APURADO')]
    property DEB_VLR_APURADO     :Double read   FDEB_VLR_APURADO     write   FDEB_VLR_APURADO;
     [FieldName('DEB_VLR_OUTROS')]
    property DEB_VLR_OUTROS      :Double read   FDEB_VLR_OUTROS      write   FDEB_VLR_OUTROS;
     [FieldName('DEB_DESC_OUTROS')]
    property DEB_DESC_OUTROS     :String read   FDEB_DESC_OUTROS     write   FDEB_DESC_OUTROS;
     [FieldName('DEB_VLR_AJUST')]
    property DEB_VLR_AJUST       :Double read   FDEB_VLR_AJUST       write   FDEB_VLR_AJUST;
     [FieldName('DEB_VLR_ESTORNO')]
    property DEB_VLR_ESTORNO     :Double read   FDEB_VLR_ESTORNO     write   FDEB_VLR_ESTORNO;
     [FieldName('DEB_DESC_ESTORNO')]
    property DEB_DESC_ESTORNO    :String read   FDEB_DESC_ESTORNO    write   FDEB_DESC_ESTORNO;
     [FieldName('CRE_VLR_APURADO')]
    property CRE_VLR_APURADO     :Double read   FCRE_VLR_APURADO     write   FCRE_VLR_APURADO;
     [FieldName('CRE_VLR_OUTROS')]
    property CRE_VLR_OUTROS      :Double read   FCRE_VLR_OUTROS      write   FCRE_VLR_OUTROS;
     [FieldName('CRE_DESC_OUTROS')]
    property CRE_DESC_OUTROS     :String read   FCRE_DESC_OUTROS     write   FCRE_DESC_OUTROS;
     [FieldName('CRE_VLR_ESTORNO')]
    property CRE_VLR_ESTORNO     :Double read   FCRE_VLR_ESTORNO     write   FCRE_VLR_ESTORNO;
     [FieldName('CRE_DESC_ESTORNO')]
    property CRE_DESC_ESTORNO    :String read   FCRE_DESC_ESTORNO    write   FCRE_DESC_ESTORNO;
     [FieldName('CRE_VLR_SUBTOTAL')]
    property CRE_VLR_SUBTOTAL    :Double read   FCRE_VLR_SUBTOTAL    write   FCRE_VLR_SUBTOTAL;
     [FieldName('CRE_VLR_PERIODO_ANT')]
    property CRE_VLR_PERIODO_ANT :Double read   FCRE_VLR_PERIODO_ANT write   FCRE_VLR_PERIODO_ANT;
     [FieldName('CRE_VLR_TOT')]
    property CRE_VLR_TOT         :Double read   FCRE_VLR_TOT         write   FCRE_VLR_TOT;
     [FieldName('SAL_VLR_DEVEDOR')]
    property SAL_VLR_DEVEDOR     :Double read   FSAL_VLR_DEVEDOR     write   FSAL_VLR_DEVEDOR;
     [FieldName('SAL_VLR_DEDUCOES')]
    property SAL_VLR_DEDUCOES    :Double read   FSAL_VLR_DEDUCOES    write   FSAL_VLR_DEDUCOES;
     [FieldName('SAL_DESC_DEDUCOES')]
    property SAL_DESC_DEDUCOES   :String read   FSAL_DESC_DEDUCOES   write   FSAL_DESC_DEDUCOES;
     [FieldName('SAL_VLR_IMPOSTO')]
    property SAL_VLR_IMPOSTO     :Double read   FSAL_VLR_IMPOSTO     write   FSAL_VLR_IMPOSTO;
     [FieldName('SAL_VLR_SALDO_CREDOR')]
    property SAL_VLR_SALDO_CREDOR:Double read   FSAL_VLR_SALDO_CREDOR write   FSAL_VLR_SALDO_CREDOR;

     [FieldName('DEB_VLR_TOTAL ')]
    property DEB_VLR_TOTAL  :Double read   FDEB_VLR_TOTAL  write   FDEB_VLR_TOTAL;

     [FieldName('STATUS')]
    property STATUS :String read FSTATUS write FSTATUS;

End;
implementation
End.

