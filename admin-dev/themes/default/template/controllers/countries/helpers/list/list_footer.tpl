{*
* 2007-2016 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2016 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
</table>
<div class="row">
  <div class="col-lg-8">
    {if $bulk_actions && $has_bulk_actions}
      <div class="btn-group bulk-actions dropup">
        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
          {l s='Bulk actions'} <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
          <li>
            <a href="#" onclick="javascript:checkDelBoxes($(this).closest('form').get(0), '{$list_id}Box[]', true);return false;">
              <i class="icon-check-sign"></i>&nbsp;{l s='Select all'}
            </a>
          </li>
          <li>
            <a href="#" onclick="javascript:checkDelBoxes($(this).closest('form').get(0), '{$list_id}Box[]', false);return false;">
              <i class="icon-check-empty"></i>&nbsp;{l s='Unselect all'}
            </a>
          </li>
          <li class="divider"></li>
          {foreach $bulk_actions as $key => $params}
            <li{if $params.text == 'divider'} class="divider"{/if}>
              {if $params.text != 'divider'}
                <a href="#" onclick="{if isset($params.confirm)}if (confirm('{$params.confirm}')){/if}sendBulkAction($(this).closest('form').get(0), 'submitBulk{$key}{$table}');">
                  {if isset($params.icon)}<i class="{$params.icon}"></i>{/if}&nbsp;{$params.text}
                </a>
              {/if}
            </li>
          {/foreach}
        </ul>
      </div>
    {/if}
  </div>
  {if !$simple_header && $list_total > 20}
    <div class="col-lg-4">
      {* Choose number of results per page *}
      <div class="pagination">
        {l s='Display'}
        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
          {$selected_pagination}
          <i class="icon-caret-down"></i>
        </button>
        <ul class="dropdown-menu">
          {foreach $pagination AS $value}
            <li>
              <a href="javascript:void(0);" class="pagination-items-page" data-items="{$value|intval}">{$value}</a>
            </li>
          {/foreach}
        </ul>
        / {$list_total} {l s='result(s)'}
        <input type="hidden" id="pagination-items-page" name="{$table}_pagination" value="{$selected_pagination|intval}"/>
      </div>
      <script type="text/javascript">
        $('.pagination-items-page').on('click', function (e) {
          e.preventDefault();
          $('#pagination-items-page').val($(this).data("items")).closest("form").submit();
        });
      </script>
      <ul class="pagination pull-right">
        <li {if $page <= 1}class="disabled"{/if}>
          <a href="javascript:void(0);" class="pagination-link" data-page="1">
            <i class="icon-double-angle-left"></i>
          </a>
        </li>
        <li {if $page <= 1}class="disabled"{/if}>
          <a href="javascript:void(0);" class="pagination-link" data-page="{$page - 1}">
            <i class="icon-angle-left"></i>
          </a>
        </li>
        {assign p 0}
        {while $p++ < $total_pages}
          {if $p < $page-2}
            <li class="disabled">
              <a href="javascript:void(0);">&hellip;</a>
            </li>
            {assign p $page-3}
          {else if $p > $page+2}
            <li class="disabled">
              <a href="javascript:void(0);">&hellip;</a>
            </li>
            {assign p $total_pages}
          {else}
            <li {if $p == $page}class="active"{/if}>
              <a href="javascript:void(0);" class="pagination-link" data-page="{$p}">{$p}</a>
            </li>
          {/if}
        {/while}
        <li {if $page > $total_pages}class="disabled"{/if}>
          <a href="javascript:void(0);" class="pagination-link" data-page="{$page + 1}">
            <i class="icon-angle-right"></i>
          </a>
        </li>
        <li {if $page > $total_pages}class="disabled"{/if}>
          <a href="javascript:void(0);" class="pagination-link" data-page="{$total_pages}">
            <i class="icon-double-angle-right"></i>
          </a>
        </li>
      </ul>
      <script type="text/javascript">
        $('.pagination-link').on('click', function (e) {
          e.preventDefault();
          $('#submitFilter' + '{$table}').val($(this).data("page")).closest("form").submit();
        });
      </script>
    </div>
  {/if}
</div>
<input type="hidden" name="token" value="{$token|escape:'html':'UTF-8'}"/>
</div>
</div>
</form>
<script type="text/javascript">
  $(document).ready(function () {
    {if $bulk_actions|count > 1}
    $('#submitBulk').click(function () {
      if ($('#select_submitBulk option:selected').data('confirm') !== undefined)
        return confirm($('#select_submitBulk option:selected').data('confirm'));
      else
        return true;
    });
    $('#select_submitBulk').change(function () {
      if ($(this).val() == 'affectzone')
        loadZones();
      else if (loaded)
        $('#zone_to_affect').fadeOut('slow');
    });
    {/if}
  });
  var loaded = false;
  function loadZones() {
    if (!loaded) {
      $.ajax({
        type: 'POST',
        headers: { "cache-control": "no-cache" },
        url: 'ajax.php?rand=' + new Date().getTime(),
        data: 'getZones=true&token={$token|escape:'html':'UTF-8'}',
        async: true,
        cache: false,
        dataType: 'json',
        success: function (data) {
          var html = $(data.data);
          html.hide();
          $('#select_submitBulk').after(html);
          html.fadeIn('slow');
        }
      });
      loaded = true;
    }
    else {
      $('#zone_to_affect').fadeIn('slow');
    }
  }
</script>
